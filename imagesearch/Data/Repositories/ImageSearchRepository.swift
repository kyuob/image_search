import Foundation

struct ImageSearchRepository: ImageSearchRepositoryProtocol {
    let networkClient: NetworkClient

    func searchImages(query: String) async throws -> [SearchImage] {
        _ = networkClient
        _ = query
        return []
    }
}
