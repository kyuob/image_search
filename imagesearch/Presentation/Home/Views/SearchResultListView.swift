import SwiftUI

struct SearchResultListView: View {
    let items: [SearchImage]
    let isLoading: Bool
    let emptyMessage: String
    let imageLoader: ImageLoading
    let bookmarkedIDs: Set<String>
    let onBookmarkTap: (SearchImage) -> Void

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if items.isEmpty {
                ContentUnavailableView(
                    "표시할 이미지가 없습니다.",
                    systemImage: "photo.on.rectangle.angled",
                    description: Text(emptyMessage)
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(items) { image in
                            SearchImageCard(
                                image: image,
                                imageLoader: imageLoader,
                                isBookmarked: bookmarkedIDs.contains(image.id),
                                onBookmarkTap: { onBookmarkTap(image) }
                            )
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
