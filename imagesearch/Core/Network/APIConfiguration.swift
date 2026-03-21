import Foundation

struct APIConfiguration {
    let baseURL = URL(string: "https://dapi.kakao.com")!

    var authorizationHeader: String {
        "KakaoAK \(restAPIKey)"
    }

    private var restAPIKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "KAKAO_REST_API_KEY") as? String,
              key.isEmpty == false else {
            assertionFailure("KAKAO_REST_API_KEY is missing")
            return ""
        }
        return key
    }
}
