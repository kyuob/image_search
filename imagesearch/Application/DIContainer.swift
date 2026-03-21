import Foundation

@MainActor
final class DIContainer {
    static let shared = DIContainer()

    private init() {}

    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 30
        return URLSession(configuration: configuration)
    }()

    lazy var networkClient: NetworkClient = {
        NetworkClient(session: session, configuration: APIConfiguration())
    }()

    lazy var bookmarkStore: BookmarkStore = {
        BookmarkStore()
    }()

    lazy var imageSearchRepository: ImageSearchRepositoryProtocol = {
        ImageSearchRepository(networkClient: networkClient)
    }()

    lazy var bookmarkRepository: BookmarkRepositoryProtocol = {
        BookmarkRepository(store: bookmarkStore)
    }()

    lazy var imageSearchUseCase: ImageSearchUseCase = {
        ImageSearchUseCase(repository: imageSearchRepository)
    }()

    lazy var bookmarkUseCase: BookmarkUseCase = {
        BookmarkUseCase(repository: bookmarkRepository)
    }()

    lazy var imageLoader: ImageLoading = {
        ImageLoader(session: session)
    }()

    func makeEnvironment() -> AppEnvironment {
        AppEnvironment(
            imageSearchUseCase: imageSearchUseCase,
            bookmarkUseCase: bookmarkUseCase,
            imageLoader: imageLoader
        )
    }
}
