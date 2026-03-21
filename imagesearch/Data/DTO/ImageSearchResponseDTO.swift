import Foundation

struct ImageSearchResponseDTO: Decodable, Sendable {
    let meta: MetaDTO
    let documents: [ImageDocumentDTO]
}

struct MetaDTO: Decodable, Sendable {
    let totalCount: Int
    let pageableCount: Int
    let isEnd: Bool

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case pageableCount = "pageable_count"
        case isEnd = "is_end"
    }
}

struct ImageDocumentDTO: Decodable, Sendable {
    let thumbnailURL: URL
    let imageURL: URL
    let width: Double
    let height: Double
    let displaySitename: String
    let docURL: URL
    let datetime: Date?

    enum CodingKeys: String, CodingKey {
        case thumbnailURL = "thumbnail_url"
        case imageURL = "image_url"
        case width
        case height
        case displaySitename = "display_sitename"
        case docURL = "doc_url"
        case datetime
    }

    func toEntity() -> SearchImage {
        SearchImage(
            id: imageURL.absoluteString,
            thumbnailURL: thumbnailURL,
            imageURL: imageURL,
            width: width,
            height: height,
            displaySiteName: displaySitename.isEmpty ? "출처 미상" : displaySitename,
            documentURL: docURL,
            dateTime: datetime
        )
    }
}
