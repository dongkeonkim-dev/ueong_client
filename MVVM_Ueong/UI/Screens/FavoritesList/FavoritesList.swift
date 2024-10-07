import SwiftUI

struct FavoritesListView: View {
    @StateObject var viewModel = FavoritesListView.ViewModel()
    
    var body: some View {
        VStack{
            HStack(){
                Text("좋아요 목록")
                    .font(.system(size: 25).weight(.bold))
                Spacer()
            }
            .padding(.horizontal, 20)

            ScrollView {
                VStack(spacing: 13) {
                    ForEach($viewModel.favoritePosts) { $post in
                        NavigationLink(
                            destination: PostDetail(viewModel: PostDetail.ViewModel(postId: post.id))
                        ) {
                            PostRow(post: $post, toggleFavorite: {_ in
                                viewModel.toggleFavorite(post: post) // toggleFavorite 함수 호출
                            })
                        }
                    }
                }
            }
        }.onAppear(){
            viewModel.fetchPage()
        }
        .refreshable {
            print("Refresh PostsList")
            viewModel.fetchPage() // 새로 고침 시 fetchPage 호출
        }
    }
}

#Preview {
    FavoritesListView()
}
