import Foundation

struct BookmarkUseCase: Sendable {
    private let repository: BookmarkRepositoryProtocol

    init(repository: BookmarkRepositoryProtocol) {
        self.repository = repository
    }

    func bookmarks() async -> [SearchImage] {
        await repository.fetchBookmarks()
    }

    func contains(_ image: SearchImage) async -> Bool {
        await repository.contains(image)
    }

    func toggle(_ image: SearchImage) async -> Bool {
        await repository.toggle(image)
    }
}
