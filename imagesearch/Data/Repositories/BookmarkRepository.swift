import Foundation

struct BookmarkRepository: BookmarkRepositoryProtocol {
    private let store: BookmarkStore

    init(store: BookmarkStore) {
        self.store = store
    }

    func fetchBookmarks() async -> [SearchImage] {
        await store.fetch()
    }

    func contains(_ image: SearchImage) async -> Bool {
        await store.contains(image)
    }

    func toggle(_ image: SearchImage) async -> Bool {
        await store.toggle(image)
    }
}
