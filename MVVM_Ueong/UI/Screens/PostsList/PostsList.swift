import SwiftUI



struct PostsList: View {
    @ObservedObject var pViewModel: PostsList.ViewModel
    @ObservedObject var wViewModel: WritePost.ViewModel
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                HStack(spacing: -15){
                    SelectRegion(
                        selection: $pViewModel.selection,
                        options: pViewModel.myVillages,
                        maxWidth: 130
                    )
                    .onChange(of: pViewModel.selection) {
                        print("Region Changed")
                        pViewModel.fetchPosts()
                    }
                    SearchBar(viewModel: pViewModel)
                }
                .zIndex(1)
                
                SelectPostOption(viewModel: pViewModel)
                
                ScrollView {
                    VStack(spacing: 13) {
                        ForEach($pViewModel.posts) { $post in
                            NavigationLink(
                                destination: PostDetail(viewModel: PostDetail.ViewModel(postId: post.id))
                            ) {
                                PostRow(post: $post, toggleFavorite: {_ in
                                    pViewModel.toggleFavorite(post: post) // toggleFavorite 함수 호출
                                })
                            }
                        }
                    }
                }
                .refreshable {
                    print("Refresh PostsList")
                    pViewModel.fetchPosts() // 새로 고침 시 fetchPage 호출
                }
            }
            
            // 오른쪽 하단 고정 버튼
            AddPostButton(pViewModel: pViewModel, wViewModel: wViewModel)
        }
    }
}

#Preview {
    PostsList(pViewModel: PostsList.ViewModel(), wViewModel: WritePost.ViewModel(village: MyVillage()))
}

