import Foundation

struct APIConfiguration: Sendable {
    let baseURL = URL(string: "https://dapi.kakao.com")!
    let restAPIKey: String = ""
}
