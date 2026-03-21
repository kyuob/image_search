import Foundation

struct APIConfiguration: Sendable {
    let baseURL = URL(string: "https://dapi.kakao.com")!

    nonisolated var authorizationHeader: String {
        "KakaoAK \(restAPIKey)"
    }

    private nonisolated var restAPIKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "KAKAO_REST_API_KEY") as? String,
              key.isEmpty == false else {
            assertionFailure("KAKAO_REST_API_KEY is missing")
            return ""
        }
        return key
    }
}
