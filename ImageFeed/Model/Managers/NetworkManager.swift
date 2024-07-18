import Foundation
import UIKit

final class NetworkManager {
    func getCuratedImagePackFromPage(_ page: Int) async throws -> CuratedImagePackResponseDTO? {
        let urlString = "curated?page=\(page)per_page=\(World.Constants.itemsPerPage)"
        if let cached = Current.cacheManager.getResponseDTO(for: urlString) {
            return cached
        } else {
            guard let result: CuratedImagePackResponseDTO = try await makeRequest(
                urlString: urlString,
                method: "GET",
                body: nil,
                headers: [:]
            ) else { return nil }
            Current.cacheManager.saveResponseDTO(result, forId: urlString)
            return result
        }
    }

    func getImageData(from urlString: String) async throws -> Data? {
        if let cached = Current.cacheManager.getImageData(for: urlString) {
            return cached
        } else {
            guard let url = URL(string: urlString) else { return nil }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let (data, response) = try await URLSession.shared.data(for: authorizeRequest(request))
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                throw NetworkError.requestFailed
            }
            Current.cacheManager.saveImageData(data, forId: urlString)
            return data
        }
    }
}

private extension NetworkManager {
    private func makeRequest<T: Decodable>(
        urlString: String,
        method: String,
        body: Data?,
        headers: [String: String]
    ) async throws -> T {
        var request = URLRequest(url: try getBaseUrl(for: urlString))
        request.httpMethod = method
        request.httpBody = body

        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        let (data, response) = try await URLSession.shared.data(for: authorizeRequest(request))

        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.requestFailed
        }
        return try JSONDecoder().decode(T.self, from: data)
    }

    private func getBaseUrl(for urlString: String) throws -> URL {
        guard let url = URL(string: "\(Constants.baseUrl)\(urlString)") else { throw NetworkError.invalidUrl }
        return url
    }

    private func authorizeRequest(_ request: URLRequest) -> URLRequest {
        var requestToSign = request
        requestToSign.setValue(Constants.apiKey, forHTTPHeaderField: "Authorization")
        return requestToSign
    }
}

private extension NetworkManager {
    private class Constants {
        static let baseUrl = "https://api.pexels.com/v1/"
        static let apiKey = "GoLOJFzOab7GCJo3BvqOM5QdRMvtIpfyoEeJOfAVyDlw0ZVBTFPXLzs5"
    }

    private enum NetworkError: Error {
        case requestFailed
        case decodingFailed
        case invalidUrl
    }
}
