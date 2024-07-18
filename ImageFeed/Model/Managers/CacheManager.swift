import Foundation

final class CacheManager {
    private let responseDTOCache = Cache<String, CuratedImagePackResponseDTO>()
    private let imageCache = Cache<String, Data>()

    func getResponseDTO(for urlString: String) -> CuratedImagePackResponseDTO? {
        responseDTOCache.value(forKey: urlString)
    }

    func saveResponseDTO(_ dto: CuratedImagePackResponseDTO, forId urlString: String) {
        responseDTOCache.insert(dto, forKey: urlString)
    }

    func getImageData(for urlString: String) -> Data? { imageCache.value(forKey: urlString) }

    func saveImageData(_ data: Data, forId urlString: String) {
        imageCache.insert(data, forKey: urlString)
    }

    func removeAll() {
        imageCache.erase()
        responseDTOCache.erase()
    }
}
