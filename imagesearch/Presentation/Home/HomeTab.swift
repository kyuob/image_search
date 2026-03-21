import Foundation

enum HomeTab: String, CaseIterable, Identifiable {
    case search = "검색 결과"
    case bookmark = "북마크"

    var id: String { rawValue }
}
