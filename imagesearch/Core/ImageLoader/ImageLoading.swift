import Foundation
import UIKit

protocol ImageLoading: Sendable {
    func image(for url: URL) async throws -> UIImage
}
