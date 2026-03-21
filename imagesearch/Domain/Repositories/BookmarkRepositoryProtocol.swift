import Foundation

protocol BookmarkRepositoryProtocol: Sendable {
    func fetchBookmarks() async -> [SearchImage]
    func contains(_ image: SearchImage) async -> Bool
    func toggle(_ image: SearchImage) async -> Bool
}
