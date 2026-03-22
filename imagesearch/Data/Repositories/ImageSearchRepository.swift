import Foundation

struct ImageSearchRepository: ImageSearchRepositoryProtocol {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func searchImages(query: String) async throws -> [SearchImage] {
        let request = APIRequest<ImageSearchResponseDTO>(
            path: "/v2/search/image",
            queryItems: [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "size", value: "30")
            ]
        )

        let response = try await networkClient.send(request)
        return response.documents.map { $0.toEntity() }
    }
}
