import Foundation

struct ImageSearchResponseDTO: Decodable {
    let meta: MetaDTO
    let documents: [ImageDocumentDTO]

    struct MetaDTO: Decodable {
        let totalCount: Int
        let pageableCount: Int
        let isEnd: Bool
    }

    struct ImageDocumentDTO: Decodable {
        let collection: String
        let thumbnailURL: String
        let imageURL: String
        let width: Int
        let height: Int
        let displaySiteName: String
        let docURL: String
        let datetime: Date
    }
}
