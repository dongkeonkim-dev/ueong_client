import SwiftUI

struct FavoritesListView: View {
    @ObservedObject var viewModel: FavoritesListView.ViewModel
    
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
                    ForEach(viewModel.favoritePosts) { post in
                        NavigationLink(
                            destination: PostDetail(viewModel: PostDetail.ViewModel(postId: post.id))
                        ) {
                            PostRow(post: post)
                        }
                    }
                }
            }
        }.onAppear(){
            viewModel.fetchPage()
        }
    }
}

#Preview {
    FavoritesListView(viewModel: FavoritesListView.ViewModel(userId: 3))
}

