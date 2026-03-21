import Combine
import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var query = ""
    @Published private(set) var searchResults: [SearchImage] = []
    @Published private(set) var bookmarks: [SearchImage] = []
    @Published private(set) var isLoading = false
    @Published var selectedTab: HomeTab = .search

    private let imageSearchUseCase: ImageSearchUseCase
    private let bookmarkUseCase: BookmarkUseCase

    init(environment: AppEnvironment) {
        imageSearchUseCase = environment.imageSearchUseCase
        bookmarkUseCase = environment.bookmarkUseCase
    }
}
