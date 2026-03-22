import Combine
import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var query = ""
    @Published private(set) var searchResults: [SearchImage] = []
    @Published private(set) var bookmarks: [SearchImage] = []
    @Published private(set) var recentQueries: [String] = []
    @Published private(set) var isLoading = false
    @Published var selectedTab: HomeTab = .search
    @Published var isShowingAlert = false
    @Published private(set) var alertMessage = ""
    @Published private(set) var searchResultScrollToken = UUID()

    private let imageSearchUseCase: ImageSearchUseCase
    private let bookmarkUseCase: BookmarkUseCase
    private var debounceTask: Task<Void, Never>?
    private var searchTask: Task<Void, Never>?
    private var latestQuery = ""
    private var lastSearchedQuery = ""
    private var hasLoadedBookmarks = false
    private var isIgnoringNextQueryChange = false
    private let recentQueriesKey = "recent_search_queries"

    init(environment: AppEnvironment) {
        imageSearchUseCase = environment.imageSearchUseCase
        bookmarkUseCase = environment.bookmarkUseCase
    }

    func onAppear() async {
        latestQuery = query
        loadRecentQueries()
    }

    func didSelectTab(_ tab: HomeTab) async {
        guard tab == .bookmark else { return }
        await Task.yield()
        await ensureBookmarksLoaded()
    }

    func updateQuery(_ query: String) {
        if isIgnoringNextQueryChange {
            isIgnoringNextQueryChange = false
            latestQuery = query
            return
        }

        latestQuery = query

        debounceTask?.cancel()
        debounceTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(1))
            guard Task.isCancelled == false else { return }
            await self?.runSearchIfNeeded()
        }
    }

    func toggleBookmark(for image: SearchImage) {
        Task {
            _ = await bookmarkUseCase.toggle(image)
            await loadBookmarks()
        }
    }

    func retrySearch() {
        Task {
            await runSearch(force: true)
        }
    }

    func selectRecentQuery(_ query: String) {
        debounceTask?.cancel()
        isIgnoringNextQueryChange = true
        self.query = query
        latestQuery = query

        Task {
            await runSearch(force: true)
        }
    }

    private func runSearchIfNeeded() async {
        let trimmed = latestQuery.trimmingCharacters(in: .whitespacesAndNewlines)

        guard trimmed.isEmpty == false else {
            debounceTask?.cancel()
            searchTask?.cancel()
            isLoading = false
            searchResults = []
            lastSearchedQuery = ""
            return
        }

        guard trimmed != lastSearchedQuery else { return }
        await runSearch(force: false)
    }

    private func runSearch(force: Bool) async {
        let trimmed = latestQuery.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            debounceTask?.cancel()
            searchTask?.cancel()
            isLoading = false
            searchResults = []
            lastSearchedQuery = ""
            return
        }

        if force == false, trimmed == lastSearchedQuery {
            return
        }

        searchTask?.cancel()
        isLoading = true
        isShowingAlert = false
        alertMessage = ""

        searchTask = Task { [weak self] in
            guard let self else { return }

            do {
                let images = try await imageSearchUseCase.execute(query: trimmed)
                guard Task.isCancelled == false else { return }

                self.searchResults = images
                self.searchResultScrollToken = UUID()
                self.isLoading = false
                if self.selectedTab != .search {
                    self.selectedTab = .search
                }
                self.lastSearchedQuery = trimmed
                self.storeRecentQuery(trimmed)

                if images.isEmpty {
                    self.presentAlert("검색 결과가 없습니다.")
                }
            } catch is CancellationError {
                self.isLoading = false
            } catch {
                guard Task.isCancelled == false else { return }
                self.searchResults = []
                self.isLoading = false
                self.presentAlert(error.localizedDescription)
            }
        }

        await searchTask?.value
    }

    private func loadBookmarks() async {
        bookmarks = await bookmarkUseCase.bookmarks()
        hasLoadedBookmarks = true
    }

    private func ensureBookmarksLoaded() async {
        guard hasLoadedBookmarks == false else { return }
        await loadBookmarks()
    }

    private func loadRecentQueries() {
        recentQueries = UserDefaults.standard.stringArray(forKey: recentQueriesKey) ?? []
    }

    private func storeRecentQuery(_ query: String) {
        var queries = recentQueries.filter { $0 != query }
        queries.insert(query, at: 0)
        recentQueries = Array(queries.prefix(3))
        UserDefaults.standard.set(recentQueries, forKey: recentQueriesKey)
    }

    private func presentAlert(_ message: String) {
        alertMessage = message
        isShowingAlert = true
    }
}
