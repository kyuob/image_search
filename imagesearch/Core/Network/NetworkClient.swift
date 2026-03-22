import Foundation

actor NetworkClient {
    private let session: URLSession
    private let configuration: APIConfiguration
    private let decoder = JSONDecoder()
    private let iso8601FormatterWithFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    private let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

    init(session: URLSession, configuration: APIConfiguration) {
        self.session = session
        self.configuration = configuration
        decoder.dateDecodingStrategy = .custom { [iso8601FormatterWithFractionalSeconds, iso8601Formatter] decoder in
            let container = try decoder.singleValueContainer()
            let value = try container.decode(String.self)

            if let date = iso8601FormatterWithFractionalSeconds.date(from: value) ?? iso8601Formatter.date(from: value) {
                return date
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Expected date string to be ISO8601-formatted."
            )
        }
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
        guard let authorizationHeader = configuration.authorizationHeader else {
            throw NetworkError.missingAPIKey
        }
        urlRequest.setValue(authorizationHeader, forHTTPHeaderField: "Authorization")
        request.headers.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        return urlRequest
    }
}
