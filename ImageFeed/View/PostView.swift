//
//  PostView.swift
//  ImageFeed
//
//  Created by никита богатырев on 18.07.2024.
//

import SwiftUI

struct PostView: View {
    @StateObject var model: PostViewModel
    var geometry: GeometryProxy

    init(content: Photo, proxy: GeometryProxy) {
        self._model = StateObject(wrappedValue: PostViewModel(content: content))
        self.geometry = proxy
    }

    var body: some View {
        ZStack(alignment: .top) {
            card
            VStack(alignment: .center, spacing: 0) {
                if model.isContentLoaded, let data = model.imageData {
                    getPicture(from: data)
                } else {
                    picturePlaceholder
                }
                pictureDetails
                Spacer()
            }
            .padding(10)
        }
        .onTapGesture {
            withAnimation {
                model.shouldShowDetailsView = true
            }
        }
        .fullScreenCover(isPresented: $model.shouldShowDetailsView, content: {
            PostDetailsView(content: model.content, placeholderData: model.imageData)
        })
    }

    private var card: some View {
        RoundedRectangle(cornerRadius: 24)
            .foregroundStyle(Color.white)
            .shadow(color: .black.opacity(0.4), radius: 8)
    }

    private var picturePlaceholder: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(Color(hex: model.content.avgColor))
    }

    private var pictureDetails: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(model.content.photographer)
                    .font(.title3)
                    .foregroundStyle(Color.black)
                    .padding(.bottom, 10)
                    .padding(.top, 10)
                Text(model.content.alt)
                    .font(.callout)
                    .foregroundStyle(Color.gray.opacity(0.7))
            }
            Spacer()
        }
    }
}

private extension PostView {
    private func getPicture(from data: Data) -> some View {
        Image.fromData(data)
            .resizable()
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
