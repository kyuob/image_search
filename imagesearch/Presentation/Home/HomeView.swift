import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @FocusState private var isSearchFieldFocused: Bool
    @State private var didAutoFocusInitialSearch = false
    private let imageLoader: ImageLoading

    init(environment: AppEnvironment) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(environment: environment))
        imageLoader = environment.imageLoader
    }

    var body: some View {
        let bookmarkedIDs = Set(viewModel.bookmarks.map(\.id))
        let isShowingSearchPlaceholder = viewModel.query.isEmpty

        NavigationStack {
            VStack(spacing: 0) {
                SearchBar(
                    text: $viewModel.query,
                    isLoading: viewModel.isLoading,
                    isFocused: $isSearchFieldFocused
                )
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, viewModel.recentQueries.isEmpty ? 16 : 10)

                if viewModel.recentQueries.isEmpty == false,
                   viewModel.selectedTab == .search,
                   isShowingSearchPlaceholder {
                    recentSearchSection
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)
                }

                TabView(selection: $viewModel.selectedTab) {
                    SearchResultListView(
                        items: viewModel.searchResults,
                        isLoading: viewModel.isLoading,
                        emptyMessage: isShowingSearchPlaceholder
                            ? "검색어를 입력하면 1초 뒤 자동으로 검색됩니다."
                            : "검색 결과가 없습니다.",
                        scrollToken: viewModel.searchResultScrollToken,
                        imageLoader: imageLoader,
                        bookmarkedIDs: bookmarkedIDs,
                        onBookmarkTap: viewModel.toggleBookmark(for:)
                    )
                    .tabItem {
                        Label("검색 결과", systemImage: "photo.stack")
                    }
                    .tag(HomeTab.search)

                    SearchResultListView(
                        items: viewModel.bookmarks,
                        isLoading: false,
                        emptyMessage: "북마크한 이미지가 없습니다.",
                        scrollToken: nil,
                        imageLoader: imageLoader,
                        bookmarkedIDs: bookmarkedIDs,
                        onBookmarkTap: viewModel.toggleBookmark(for:)
                    )
                    .tabItem {
                        Label("북마크", systemImage: "bookmark")
                    }
                    .tag(HomeTab.bookmark)
                }
                .tint(.blue)
            }
            .navigationTitle("Image Search")
            .toolbarTitleDisplayMode(.inline)
            .allowsHitTesting(viewModel.isPreparingScreen == false)
        }
        .overlay {
            if viewModel.isPreparingScreen {
                initialLoadingOverlay
            }
        }
        .task {
            await viewModel.onAppear()
        }
        .task(id: viewModel.isPreparingScreen) {
            guard viewModel.isPreparingScreen == false,
                  didAutoFocusInitialSearch == false else { return }

            didAutoFocusInitialSearch = true
            isSearchFieldFocused = true
        }
        .onChange(of: viewModel.query) { _, newValue in
            viewModel.updateQuery(newValue)
        }
        .task(id: viewModel.selectedTab) {
            await viewModel.didSelectTab(viewModel.selectedTab)
        }
        .alert("안내", isPresented: $viewModel.isShowingAlert) {
            Button("확인", role: .cancel) {}
            if viewModel.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
                Button("다시 시도") {
                    viewModel.retrySearch()
                }
            }
        } message: {
            Text(viewModel.alertMessage)
        }
    }

    private var initialLoadingOverlay: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 14) {
                ProgressView()
                    .controlSize(.regular)

                Text("준비 중입니다...")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 24)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .transition(.opacity)
    }

    private var recentSearchSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("최근 검색어")
                .font(.caption)
                .foregroundStyle(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(viewModel.recentQueries, id: \.self) { query in
                        Button {
                            isSearchFieldFocused = false
                            viewModel.selectRecentQuery(query)
                        } label: {
                            Text(query)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.primary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(uiColor: .secondarySystemBackground), in: Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

}
