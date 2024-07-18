import Foundation

struct CuratedImagePackResponseDTO: Codable {
    let page: Int
    let perPage: Int
    let photos: [Photo]
    let prevPage: String?
    let nextPage: String?

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case photos
        case prevPage = "prev_page"
        case nextPage = "next_page"
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = try container.decode(Int.self, forKey: .page)
        self.perPage = try container.decode(Int.self, forKey: .perPage)
        self.photos = try container.decode([Photo].self, forKey: .photos)
        self.prevPage = try? container.decode(String.self, forKey: .prevPage)
        self.nextPage = try? container.decode(String.self, forKey: .nextPage)
    }
}

// MARK: - Photo
struct Photo: Codable {
    let id, width, height: Int
    let url: String
    let photographer: String
    let photographerURL: String
    let photographerID: Int
    let avgColor: String
    let src: Src
    let liked: Bool
    let alt: String

    enum CodingKeys: String, CodingKey {
        case id, width, height, url, photographer
        case photographerURL = "photographer_url"
        case photographerID = "photographer_id"
        case avgColor = "avg_color"
        case src, liked, alt
    }
}

// MARK: - Src
struct Src: Codable {
    let original, large2X, large, medium: String
    let small, portrait, landscape, tiny: String

    enum CodingKeys: String, CodingKey {
        case original
        case large2X = "large2x"
        case large, medium, small, portrait, landscape, tiny
    }
}
