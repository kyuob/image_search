import Foundation

struct ImageSearchUseCase: Sendable {
    let repository: ImageSearchRepositoryProtocol

    func execute(query: String) async throws -> [SearchImage] {
        try await repository.searchImages(query: query)
    }
}
