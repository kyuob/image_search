import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @FocusState private var isSearchFieldFocused: Bool
    private let imageLoader: ImageLoading

    init(environment: AppEnvironment) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(environment: environment))
        imageLoader = environment.imageLoader
    }

    var body: some View {
        let bookmarkedIDs = Set(viewModel.bookmarks.map(\.id))

        NavigationStack {
            VStack(spacing: 0) {
                SearchBar(
                    text: $viewModel.query,
                    isLoading: viewModel.isLoading,
                    isFocused: $isSearchFieldFocused
                )
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 16)

                Group {
                    switch viewModel.selectedTab {
                    case .search:
                        SearchResultListView(
                            items: viewModel.searchResults,
                            isLoading: viewModel.isLoading,
                            emptyMessage: viewModel.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                ? "검색어를 입력하면 1초 뒤 자동으로 검색됩니다."
                                : "검색 결과가 없습니다.",
                            scrollToken: viewModel.searchResultScrollToken,
                            imageLoader: imageLoader,
                            bookmarkedIDs: bookmarkedIDs,
                            onBookmarkTap: viewModel.toggleBookmark(for:)
                        )
                    case .bookmark:
                        SearchResultListView(
                            items: viewModel.bookmarks,
                            isLoading: false,
                            emptyMessage: "북마크한 이미지가 없습니다.",
                            scrollToken: nil,
                            imageLoader: imageLoader,
                            bookmarkedIDs: bookmarkedIDs,
                            onBookmarkTap: viewModel.toggleBookmark(for:)
                        )
                    }
                }
            }
            .navigationTitle("Image Search")
            .toolbarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                bottomTabBar
            }
        }
        .task {
            viewModel.onAppear()
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

    private var bottomTabBar: some View {
        HStack(spacing: 0) {
            ForEach(HomeTab.allCases) { tab in
                Button {
                    viewModel.selectedTab = tab
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: iconName(for: tab))
                            .font(.system(size: 19, weight: .semibold))

                        Text(tab.rawValue)
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundStyle(viewModel.selectedTab == tab ? Color.blue : Color(uiColor: .systemGray))
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .background(Color.white)
        .overlay(alignment: .top) {
            Divider()
        }
    }

    private func iconName(for tab: HomeTab) -> String {
        switch tab {
        case .search:
            return viewModel.selectedTab == .search ? "photo.stack.fill" : "photo.stack"
        case .bookmark:
            return viewModel.selectedTab == .bookmark ? "bookmark.fill" : "bookmark"
        }
    }
}
