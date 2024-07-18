import Foundation

final class PostViewModel: ObservableObject {
    let content: Photo
    @Published var imageData: Data?
    @Published var isContentLoaded = false
    @Published var shouldShowDetailsView = false

    init(content: Photo) {
        self.content = content
        startImageDownload(from: content.src.medium)
    }
}

private extension PostViewModel {
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
