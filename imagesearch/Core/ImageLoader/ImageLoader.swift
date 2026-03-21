import Foundation
import UIKit

actor ImageLoader: ImageLoading {
    private let session: URLSession
    private let cache = NSCache<NSURL, UIImage>()
    private var runningTasks: [URL: Task<UIImage, Error>] = [:]

    init(session: URLSession) {
        self.session = session
        cache.countLimit = 200
    }

    func image(for url: URL) async throws -> UIImage {
        if let cached = cache.object(forKey: url as NSURL) {
            return cached
        }

        if let runningTask = runningTasks[url] {
            return try await runningTask.value
        }

        let task = Task<UIImage, Error> {
            let (data, response) = try await session.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                throw NetworkError.invalidResponse
            }

            guard let image = UIImage(data: data) else {
                throw NetworkError.decodingFailed
            }

            return image
        }

        runningTasks[url] = task

        do {
            let image = try await task.value
            cache.setObject(image, forKey: url as NSURL)
            runningTasks[url] = nil
            return image
        } catch {
            runningTasks[url] = nil
            throw error
        }
    }
}
