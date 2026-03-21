import SwiftUI
import UIKit

struct RemoteImageView: View {
    let url: URL
    let imageLoader: ImageLoading

    @State private var phase: Phase = .empty

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemBackground))

            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            case .failure:
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                    Text("이미지를 불러오지 못했습니다.")
                        .font(.footnote)
                }
                .foregroundStyle(.secondary)
            }
        }
        .task(id: url) {
            await loadImage()
        }
    }

    private func loadImage() async {
        phase = .empty

        do {
            let image = try await imageLoader.image(for: url)
            phase = .success(image)
        } catch {
            phase = .failure
        }
    }
}

extension RemoteImageView {
    enum Phase {
        case empty
        case success(UIImage)
        case failure
    }
}
