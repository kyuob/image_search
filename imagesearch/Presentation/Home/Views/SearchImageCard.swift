import SwiftUI

struct SearchImageCard: View {
    let image: SearchImage
    let imageLoader: ImageLoading
    let isBookmarked: Bool
    let onBookmarkTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            RemoteImageView(url: image.imageURL, imageLoader: imageLoader)
                .frame(maxWidth: .infinity)
                .aspectRatio(1 / image.aspectRatio, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(alignment: .topTrailing) {
                    Button(action: onBookmarkTap) {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(isBookmarked ? .yellow : .white)
                            .padding(10)
                            .background(.black.opacity(0.45), in: Circle())
                    }
                    .padding(12)
                }
                .overlay(alignment: .bottomLeading) {
                    if isBookmarked {
                        Label("북마크됨", systemImage: "checkmark.circle.fill")
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(.thinMaterial, in: Capsule())
                            .padding(12)
                    }
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(image.displaySiteName)
                    .font(.headline)
                    .lineLimit(1)

                Text(image.documentURL.absoluteString)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
    }
}
