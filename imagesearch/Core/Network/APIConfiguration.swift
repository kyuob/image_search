import Foundation

struct APIConfiguration {
    let baseURL = URL(string: "https://dapi.kakao.com")!

    var authorizationHeader: String? {
        guard let restAPIKey else { return nil }
        return "KakaoAK \(restAPIKey)"
    }

    private var restAPIKey: String? {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "KAKAO_REST_API_KEY") as? String,
              key.isEmpty == false else {
            return nil
        }
        return key
    }
}
