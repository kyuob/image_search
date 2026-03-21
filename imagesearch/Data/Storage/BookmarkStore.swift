import Foundation

actor BookmarkStore {
    private let userDefaults: UserDefaults
    private let storageKey = "bookmarked_images"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func fetch() -> [SearchImage] {
        guard let data = userDefaults.data(forKey: storageKey) else {
            return []
        }

        do {
            return try JSONDecoder().decode([SearchImage].self, from: data)
        } catch {
            return []
        }
    }

    func contains(_ image: SearchImage) -> Bool {
        fetch().contains(image)
    }

    func toggle(_ image: SearchImage) -> Bool {
        var bookmarks = fetch()

        if let index = bookmarks.firstIndex(of: image) {
            bookmarks.remove(at: index)
            save(bookmarks)
            return false
        } else {
            bookmarks.insert(image, at: 0)
            save(bookmarks)
            return true
        }
    }

    private func save(_ bookmarks: [SearchImage]) {
        guard let data = try? JSONEncoder().encode(bookmarks) else {
            return
        }
        userDefaults.set(data, forKey: storageKey)
    }
}
