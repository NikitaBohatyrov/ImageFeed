import Foundation

final class FeedViewModel: ObservableObject {
    @Published var posts: [Photo] = []
    @Published var loadingInProgress = false
    var currentPage: Int = 1

    init() {
        loadPack(for: currentPage)
    }

    func refreshFeed() {
        let pageToLoad = 1
        Current.cacheManager.removeAll()
        loadPack(for: pageToLoad, refresh: true)
    }

    func loadNextPack() {
        loadPack(for: currentPage + 1)
    }

    func loadPrevPack() {
        let pageToLoad = currentPage - 1 >= 1 ? currentPage - 1 : 1
        guard currentPage != pageToLoad else { return }
        loadPack(for: pageToLoad)
    }
}

private extension FeedViewModel {
    private func loadPack(for pageNumber: Int, refresh: Bool = false) {
        loadingInProgress = true
        Task {
            do {
                guard let pack = try await Current.networkManager.getCuratedImagePackFromPage(pageNumber) else { return }
                await MainActor.run {
                    if refresh {
                        self.posts = pack.photos
                        self.currentPage = pageNumber
                        self.loadingInProgress = false
                        return
                    }
                    if posts.count < World.Constants.itemsPerPage*2 {
                        if pageNumber > currentPage {
                            self.posts.append(contentsOf: pack.photos)
                        } else if pageNumber < currentPage {
                            self.posts.insert(contentsOf: pack.photos, at: 0)
                        } else {
                            self.posts = pack.photos
                        }
                    } else {
                        if pageNumber > currentPage {
                            self.posts.append(contentsOf: pack.photos)
                            self.posts = Array(posts.dropFirst(World.Constants.itemsPerPage))
                        } else {
                            self.posts.insert(contentsOf: pack.photos, at: 0)
                            self.posts = Array(posts.dropLast(World.Constants.itemsPerPage))
                        }
                    }
                    self.currentPage = pageNumber
                    self.loadingInProgress = false
                }
            } catch {
                debugPrint(error)
            }
        }
    }
}
