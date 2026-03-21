import SwiftUI

struct SearchResultListView: View {
    let items: [SearchImage]
    let isLoading: Bool
    let emptyMessage: String
    let scrollToken: UUID?
    let imageLoader: ImageLoading
    let bookmarkedIDs: Set<String>
    let onBookmarkTap: (SearchImage) -> Void

    var body: some View {
        Group {
            if isLoading && items.isEmpty {
                VStack(spacing: 12) {
                    ProgressView()
                    Text("검색 중입니다...")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if items.isEmpty {
                ContentUnavailableView(
                    "표시할 이미지가 없습니다.",
                    systemImage: "photo.on.rectangle.angled",
                    description: Text(emptyMessage)
                )
            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        Color.clear
                            .frame(height: 0)
                            .id("scroll-top")

                        LazyVStack(spacing: 16) {
                            ForEach(items) { image in
                                SearchImageCard(
                                    image: image,
                                    imageLoader: imageLoader,
                                    isBookmarked: bookmarkedIDs.contains(image.id),
                                    onBookmarkTap: {
                                        onBookmarkTap(image)
                                    }
                                )
                            }
                        }
                        .padding(.bottom, 24)
                    }
                    .onChange(of: scrollToken) { _, token in
                        guard token != nil else { return }

                        withAnimation(.easeInOut(duration: 0.2)) {
                            proxy.scrollTo("scroll-top", anchor: .top)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
