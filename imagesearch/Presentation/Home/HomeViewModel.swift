import Combine
import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var query = ""
    @Published private(set) var searchResults: [SearchImage] = []
    @Published private(set) var bookmarks: [SearchImage] = []
    @Published private(set) var isLoading = false
    @Published var selectedTab: HomeTab = .search
    @Published var isShowingAlert = false
    @Published private(set) var alertMessage = ""

    private let imageSearchUseCase: ImageSearchUseCase
    private let bookmarkUseCase: BookmarkUseCase
    private var hasLoadedBookmarks = false

    init(environment: AppEnvironment) {
        imageSearchUseCase = environment.imageSearchUseCase
        bookmarkUseCase = environment.bookmarkUseCase
    }

    func onAppear() {
        guard hasLoadedBookmarks == false else { return }
        hasLoadedBookmarks = true

        Task {
            await loadBookmarks()
        }
    }

    func search() {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard trimmedQuery.isEmpty == false else {
            presentAlert(NetworkError.emptyQuery.localizedDescription)
            return
        }

        Task {
            isLoading = true
            isShowingAlert = false
            alertMessage = ""

            do {
                let images = try await imageSearchUseCase.execute(query: trimmedQuery)
                searchResults = images
                selectedTab = .search
                isLoading = false

                if images.isEmpty {
                    presentAlert("검색 결과가 없습니다.")
                }
            } catch {
                searchResults = []
                isLoading = false
                presentAlert(error.localizedDescription)
            }
        }
    }

    func toggleBookmark(for image: SearchImage) {
        Task {
            _ = await bookmarkUseCase.toggle(image)
            await loadBookmarks()
        }
    }

    private func loadBookmarks() async {
        bookmarks = await bookmarkUseCase.bookmarks()
    }

    private func presentAlert(_ message: String?) {
        alertMessage = message ?? "알 수 없는 오류가 발생했습니다."
        isShowingAlert = true
    }
}
