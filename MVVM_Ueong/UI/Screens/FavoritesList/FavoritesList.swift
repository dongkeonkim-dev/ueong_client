import SwiftUI

struct FavoritesListView: View {
    @ObservedObject var viewModel: FavoritesListView.ViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 13) {
                    ForEach(viewModel.favoritePosts) { post in
                        NavigationLink(
                            destination: PostDetail(viewModel: PostDetail.ViewModel(postID: post.id))
                        ) {
                            PostRow(post: post)
                        }
                    }
                }
             
            }
      
        }
    }
}

#Preview {
    FavoritesListView(viewModel: FavoritesListView.ViewModel(userId: 3))
}

