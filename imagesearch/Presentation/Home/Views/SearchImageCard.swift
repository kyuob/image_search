import SwiftUI

struct SearchImageCard: View {
    let image: SearchImage
    let imageLoader: ImageLoading
    let isBookmarked: Bool
    let onBookmarkTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            RemoteImageView(url: image.thumbnailURL, imageLoader: imageLoader)
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            HStack {
                Text(image.displaySiteName.isEmpty ? "출처 준비 중" : image.displaySiteName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                Button(action: onBookmarkTap) {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(uiColor: .secondarySystemBackground))
        )
    }
}
