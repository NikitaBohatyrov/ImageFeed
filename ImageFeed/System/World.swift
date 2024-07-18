import Foundation

var Current = World()

/// Mega-singleton: https://www.pointfree.co/blog/posts/21-how-to-control-the-world
final class World {
    let networkManager = NetworkManager()

    let cacheManager = CacheManager()

    class Constants {
        static let itemsPerPage = 15
    }
}
