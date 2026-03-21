import Foundation

protocol BookmarkRepositoryProtocol: Sendable {
    func bookmarks() async -> [SearchImage]
    func toggle(_ image: SearchImage) async -> Bool
}
