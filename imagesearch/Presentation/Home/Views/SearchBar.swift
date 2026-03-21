import SwiftUI

struct SearchBar: View {
    let text: Binding<String>
    let isLoading: Bool
    let isFocused: FocusState<Bool>.Binding

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField("이미지 검색", text: text)
                .focused(isFocused)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            if isLoading {
                ProgressView()
                    .controlSize(.small)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}
