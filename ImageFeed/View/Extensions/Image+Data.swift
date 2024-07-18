import SwiftUI

extension Image {
    static func fromData(_ data: Data) -> Image {
        let uiImage = UIImage(data: data) ?? UIImage()
        return Image(uiImage: uiImage)
    }
}
