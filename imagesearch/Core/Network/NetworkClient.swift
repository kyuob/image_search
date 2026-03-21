import Foundation

struct NetworkClient {
    let session: URLSession
    let configuration: APIConfiguration

    func request<T: Decodable>(_ request: APIRequest, as type: T.Type) async throws -> T {
        _ = session
        _ = configuration
        _ = request
        _ = type
        throw NetworkError.notImplemented
    }
}
