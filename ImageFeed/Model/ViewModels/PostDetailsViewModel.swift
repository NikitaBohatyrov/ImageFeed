import Foundation

final class PostDetailsViewModel: ObservableObject {
    let content: Photo
    @Published var imageData: Data?
    @Published var placeholderData: Data?
    @Published var isContentLoaded = false
    @Published var isAnimationInProgress = false

    init(_ content: Photo, _ placeHolderData: Data? = nil) {
        self.content = content
        self._placeholderData = .init(initialValue: placeHolderData)
        startImageDownload(from: content.src.original)
    }
}

private extension PostDetailsViewModel {
    private func startImageDownload(from url: String) {
        Task {
            do {
                let data = try await Current.networkManager.getImageData(from: url)
                await MainActor.run {
                    imageData = data
                    isContentLoaded = true
                }
            } catch {
                debugPrint(error)
            }
        }
    }
}
