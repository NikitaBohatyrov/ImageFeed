import SwiftUI

struct PostDetailsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var model: PostDetailsViewModel

    init(content: Photo, placeholderData: Data? = nil) {
        self._model = StateObject(wrappedValue: PostDetailsViewModel(content, placeholderData))
    }

    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .center, spacing: 0) {
                picture
                description
                Spacer()
            }
            header
                .padding(.top, 40)
                .padding(.trailing, 20)
        }
        .ignoresSafeArea(edges: .top)
    }

    @ViewBuilder private var picture: some View {
        if model.isContentLoaded, let data = model.imageData {
            Image.fromData(data)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else if let data = model.placeholderData {
            Image.fromData(data)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            RoundedRectangle(cornerRadius: 24)
                .foregroundStyle(Color(hex: model.content.avgColor))
        }
    }

    private var header: some View {
        Button {dismiss()} label: {
            HStack(alignment: .center, spacing: 0) {
                Spacer()
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundStyle(Color.gray)
            }
        }
    }

    private var description: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Photo by:\(model.content.photographer)")
                    .font(.title2)
                    .foregroundStyle(Color.black)
                    .padding(.bottom, 20)
                    .padding(.top, 10)
                Text(model.content.alt)
                    .font(.callout)
                    .foregroundStyle(Color.gray.opacity(0.7))
            }
            Spacer()
        }
        .padding(.horizontal, 10)
    }
}
