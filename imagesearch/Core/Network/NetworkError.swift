import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingFailed
    case httpStatus(Int)
    case emptyQuery

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "요청 주소를 만들지 못했습니다."
        case .invalidResponse:
            return "서버 응답을 확인할 수 없습니다."
        case .decodingFailed:
            return "검색 결과를 해석하지 못했습니다."
        case .httpStatus(let code):
            return "서버 요청에 실패했습니다. (\(code))"
        case .emptyQuery:
            return "검색어를 입력해 주세요."
        }
    }
}
