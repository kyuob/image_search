import SwiftUI

struct SearchImageCard: View {
    let image: SearchImage
    let imageLoader: ImageLoading
    let isBookmarked: Bool
    let onBookmarkTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            RemoteImageView(url: image.imageURL ?? image.thumbnailURL, imageLoader: imageLoader)
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(image.displaySiteName)
                        .font(.subheadline.weight(.semibold))

                    if let dateTime = image.dateTime {
                        Text(dateTime.formatted(date: .numeric, time: .shortened))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                Button(action: onBookmarkTap) {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .font(.title3)
                        .foregroundStyle(isBookmarked ? Color.accentColor : .secondary)
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
