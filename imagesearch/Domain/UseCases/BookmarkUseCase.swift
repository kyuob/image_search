import Foundation

struct BookmarkUseCase: Sendable {
    let repository: BookmarkRepositoryProtocol

    func bookmarks() async -> [SearchImage] {
        await repository.bookmarks()
    }

    func toggle(_ image: SearchImage) async -> Bool {
        await repository.toggle(image)
    }
}
