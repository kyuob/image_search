import Foundation

protocol ImageSearchRepositoryProtocol: Sendable {
    func searchImages(query: String) async throws -> [SearchImage]
}
