import Foundation

struct BookmarkRepository: BookmarkRepositoryProtocol {
    let store: BookmarkStore

    func bookmarks() async -> [SearchImage] {
        await store.fetch()
    }

    func toggle(_ image: SearchImage) async -> Bool {
        await store.toggle(image)
    }
}
