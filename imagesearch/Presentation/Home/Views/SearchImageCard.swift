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
                if image.displaySiteName.isEmpty == false {
                    Text(image.displaySiteName)
                        .font(.headline)
                        .lineLimit(1)
                }

                HStack(spacing: 8) {
                    Label("\(Int(image.width)) x \(Int(image.height))", systemImage: "rectangle.compress.vertical")
                    if let dateText = formattedDateText {
                        Label(dateText, systemImage: "calendar")
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)

                Link(destination: image.documentURL) {
                    Label("원문 보기", systemImage: "arrow.up.right.square")
                        .font(.footnote.weight(.medium))
                }
                .foregroundStyle(.blue)
            }
        }
    }

    private var formattedDateText: String? {
        guard let date = image.dateTime else { return nil }

        let calendar = Calendar.current
        if calendar.isDateInToday(date) || calendar.isDateInYesterday(date) {
            return Self.relativeFormatter.localizedString(for: date, relativeTo: .now)
        }

        return date.formatted(date: .abbreviated, time: .omitted)
    }
}

private extension SearchImageCard {
    static let relativeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter
    }()
}
