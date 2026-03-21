import SwiftUI

struct RemoteImageView: View {
    let url: URL?
    let imageLoader: ImageLoading

    var body: some View {
        Rectangle()
            .fill(Color(uiColor: .secondarySystemBackground))
            .overlay {
                Image(systemName: "photo")
                    .foregroundStyle(.secondary)
            }
    }
}
