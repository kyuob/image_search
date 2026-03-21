import Foundation

struct ImageSearchRepository: ImageSearchRepositoryProtocol {
    let networkClient: NetworkClient

    func searchImages(query: String) async throws -> [SearchImage] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard trimmedQuery.isEmpty == false else {
            throw NetworkError.emptyQuery
        }

        let request = APIRequest<ImageSearchResponseDTO>(
            path: "/v2/search/image",
            queryItems: [
                URLQueryItem(name: "query", value: trimmedQuery),
                URLQueryItem(name: "size", value: "30")
            ]
        )

        let response = try await networkClient.send(request)
        return response.documents.map { $0.toEntity() }
    }
}
