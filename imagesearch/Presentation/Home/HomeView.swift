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
                SearchBar(
                    text: $viewModel.query,
                    isLoading: viewModel.isLoading,
                    onSubmit: viewModel.search
                )

                Picker("탭", selection: $viewModel.selectedTab) {
                    ForEach(HomeTab.allCases) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)

                SearchResultListView(
                    items: viewModel.selectedTab == .search ? viewModel.searchResults : viewModel.bookmarks,
                    isLoading: viewModel.isLoading,
                    emptyMessage: viewModel.selectedTab == .search
                        ? "검색어를 입력하고 검색 버튼을 눌러 주세요."
                        : "북마크한 이미지가 없습니다.",
                    imageLoader: imageLoader,
                    bookmarkedIDs: Set(viewModel.bookmarks.map(\.id)),
                    onBookmarkTap: viewModel.toggleBookmark(for:)
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .navigationTitle("Image Search")
        }
        .task {
            viewModel.onAppear()
        }
        .alert("안내", isPresented: $viewModel.isShowingAlert) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}
