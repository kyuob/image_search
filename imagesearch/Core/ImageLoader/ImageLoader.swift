import Foundation
import UIKit

final class ImageLoader: ImageLoading, @unchecked Sendable {
    private let session: URLSession
    private let cache: NSCache<NSURL, UIImage>

    init(session: URLSession) {
        let cache = NSCache<NSURL, UIImage>()
        cache.countLimit = 200

        self.session = session
        self.cache = cache
    }

    func image(for url: URL) async throws -> UIImage {
        if let cached = cache.object(forKey: url as NSURL) {
            return cached
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.invalidResponse
        }

        guard let image = UIImage(data: data) else {
            throw NetworkError.decodingFailed
        }

        cache.setObject(image, forKey: url as NSURL)
        return image
    }
}
