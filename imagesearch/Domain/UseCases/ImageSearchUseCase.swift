import Foundation

struct ImageSearchUseCase: Sendable {
    private let repository: ImageSearchRepositoryProtocol

    init(repository: ImageSearchRepositoryProtocol) {
        self.repository = repository
    }

    func execute(query: String) async throws -> [SearchImage] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard trimmed.isEmpty == false else {
            throw NetworkError.emptyQuery
        }

        return try await repository.searchImages(query: trimmed)
    }
}
