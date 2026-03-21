import Foundation

actor BookmarkStore {
    func fetch() -> [SearchImage] {
        []
    }

    func toggle(_ image: SearchImage) -> Bool {
        _ = image
        return false
    }
}
