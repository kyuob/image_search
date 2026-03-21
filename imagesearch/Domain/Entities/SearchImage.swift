import Foundation

struct SearchImage: Identifiable, Equatable, Codable, Sendable {
    let id: String
    let thumbnailURL: URL
    let imageURL: URL
    let width: Double
    let height: Double
    let displaySiteName: String
    let documentURL: URL
    let dateTime: Date?

    var aspectRatio: Double {
        guard width > 0, height > 0 else { return 1 }
        return height / width
    }
}
