import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    private let imageLoader: ImageLoading

    init(environment: AppEnvironment) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(environment: environment))
        imageLoader = environment.imageLoader
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                SearchBar(text: $viewModel.query, isLoading: viewModel.isLoading)

                SearchResultListView(
                    items: viewModel.selectedTab == .search ? viewModel.searchResults : viewModel.bookmarks,
                    isLoading: viewModel.isLoading,
                    emptyMessage: "1단계 구조 작업이 완료되었습니다.",
                    imageLoader: imageLoader,
                    bookmarkedIDs: [],
                    onBookmarkTap: { _ in }
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .navigationTitle("Image Search")
        }
    }
}
