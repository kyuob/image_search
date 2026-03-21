import Foundation
import UIKit

actor ImageLoader: ImageLoading {
    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func image(for url: URL) async throws -> UIImage {
        _ = session
        _ = url
        throw NetworkError.notImplemented
    }
}
