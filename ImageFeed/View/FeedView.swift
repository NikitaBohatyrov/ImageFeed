import SwiftUI

struct FeedView: View {
    @StateObject var model = FeedViewModel()
    @State var currentPost: Int?

    var body: some View {
        GeometryReader { geometry in
            VStack {
                header
                getFeedScrollView(geometry)
                .onChange(of: $currentPost.wrappedValue) { oldValue, newValue in
                    assesScrollViewPosition(oldValue, newValue)
                }
                .refreshable {
                    model.refreshFeed()
                }
            }
        }
        .ignoresSafeArea(edges: .vertical)
    }

    var header: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(Color.white)
                .frame(height: 100)
                .shadow(color: .black.opacity(0.3), radius: 4, y: 1)
            Text("New to you")
                .font(.title2)
                .foregroundStyle(Color.gray)
                .padding(.bottom, 10)
        }
    }
}

private extension FeedView {
    private func getFeedScrollView(_ geometry: GeometryProxy) -> some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .center, spacing: 0) {
                ForEach(model.posts, id: \.id) { post in
                    PostView(content: post, proxy: geometry)
                        .frame(
                            width: geometry.size.width * 0.95,
                            height: geometry.size.width * 0.95
                        )
                        .padding(.bottom, 10)
                        .id(post.id)
                }
                .padding(.top, 10)
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $currentPost, anchor: .center)
    }

    private func assesScrollViewPosition(_ oldValue: Int?, _ newValue: Int?) {
        guard oldValue != newValue else { return }
        if model.posts.suffix(7).contains(where: {$0.id == newValue}),
           !model.loadingInProgress {
            model.loadNextPack()
        } else if model.posts.prefix(7).contains(where: {$0.id == newValue}),
                  !model.loadingInProgress {
            model.loadPrevPack()
        }
    }
}

#Preview {
    FeedView()
}
