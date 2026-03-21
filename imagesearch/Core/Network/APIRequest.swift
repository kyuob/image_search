import Foundation

protocol APIRequest {
    var baseURL: URL { get }
    var path: String { get }
    var method: String { get }
    var queryItems: [URLQueryItem] { get }
    var headers: [String: String] { get }
}
