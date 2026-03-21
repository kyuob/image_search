import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingFailed
    case notImplemented

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        case .invalidResponse:
            return "응답을 확인할 수 없습니다."
        case .decodingFailed:
            return "데이터를 해석할 수 없습니다."
        case .notImplemented:
            return "아직 구현되지 않은 기능입니다."
        }
    }
}
