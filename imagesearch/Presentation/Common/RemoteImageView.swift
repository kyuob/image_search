import SwiftUI
import UIKit

struct RemoteImageView: View {
    let url: URL
    let imageLoader: ImageLoading

    @State private var phase: Phase = .empty
    @State private var loadToken = UUID()
    @State private var isSkeletonAnimating = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemBackground))

            switch phase {
            case .empty:
                skeletonView
            case .success(let image):
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            case .failure:
                VStack(spacing: 10) {
                    Image(systemName: "photo.badge.exclamationmark")
                        .font(.system(size: 20, weight: .semibold))

                    Text("이미지를 불러오지 못했습니다.")
                        .font(.footnote.weight(.medium))

                    Button("다시 시도") {
                        retry()
                    }
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(uiColor: .tertiarySystemBackground), in: Capsule())
                }
                .foregroundStyle(.secondary)
            }
        }
        .task(id: loadToken) {
            await loadImage()
        }
        .onDisappear {
            isSkeletonAnimating = false
        }
    }

    private var skeletonView: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color(uiColor: .tertiarySystemBackground))

                LinearGradient(
                    colors: [
                        .clear,
                        .white.opacity(0.45),
                        .clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(width: max(geometry.size.width * 0.45, 120))
                .rotationEffect(.degrees(12))
                .offset(x: isSkeletonAnimating ? geometry.size.width : -geometry.size.width)
            }
            .clipped()
            .onAppear {
                guard isSkeletonAnimating == false else { return }
                withAnimation(.linear(duration: 1.1).repeatForever(autoreverses: false)) {
                    isSkeletonAnimating = true
                }
            }
        }
        .overlay {
            ProgressView()
                .controlSize(.small)
        }
    }

    private func loadImage() async {
        phase = .empty

        do {
            let image = try await imageLoader.image(for: url)
            isSkeletonAnimating = false
            phase = .success(image)
        } catch {
            isSkeletonAnimating = false
            phase = .failure
        }
    }

    private func retry() {
        isSkeletonAnimating = false
        loadToken = UUID()
    }
}

extension RemoteImageView {
    enum Phase {
        case empty
        case success(UIImage)
        case failure
    }
}
