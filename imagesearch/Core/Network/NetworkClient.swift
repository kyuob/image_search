import Foundation

actor NetworkClient {
    private let session: URLSession
    private let configuration: APIConfiguration
    private let decoder = JSONDecoder()

    init(session: URLSession, configuration: APIConfiguration) {
        self.session = session
        self.configuration = configuration
        decoder.dateDecodingStrategy = .iso8601
    }

    func send<Response: Decodable>(_ request: APIRequest<Response>) async throws -> Response {
        let urlRequest = try makeURLRequest(for: request)
        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.httpStatus(httpResponse.statusCode)
        }

        do {
            return try decoder.decode(Response.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }

    private func makeURLRequest<Response>(for request: APIRequest<Response>) throws -> URLRequest {
        guard var components = URLComponents(
            url: configuration.baseURL.appendingPathComponent(request.path),
            resolvingAgainstBaseURL: false
        ) else {
            throw NetworkError.invalidURL
        }

        if request.queryItems.isEmpty == false {
            components.queryItems = request.queryItems
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.setValue(configuration.authorizationHeader, forHTTPHeaderField: "Authorization")
        request.headers.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        return urlRequest
    }
}
