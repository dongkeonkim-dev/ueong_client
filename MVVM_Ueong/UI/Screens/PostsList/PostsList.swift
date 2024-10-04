import SwiftUI



struct PostsList: View {
    @ObservedObject var viewModel: PostsList.ViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                HStack(spacing: -15){
                    SelectRegion(
                        selection: $viewModel.selection,
                        options: viewModel.myVillages,
                        maxWidth: 130
                    )
                    .onChange(of: viewModel.selection) {
                        print("Region Changed")
                        viewModel.fetchPosts()
                    }
                    SearchBar(viewModel: viewModel)
                }
                .zIndex(1)
                
                SelectPostOption(viewModel: viewModel)
                
                ScrollView {
                    VStack(spacing: 13) {
                        ForEach(viewModel.posts) { post in
                            NavigationLink(
                                destination: PostDetail(viewModel: PostDetail.ViewModel(postId: post.id))
                            ) {
                                PostRow(post: post)
                            }
                        }
                    }
                }
                .refreshable {
                    print("Refresh PostsList")
                    viewModel.fetchPosts() // 새로 고침 시 fetchPage 호출
                }
            }
            
            // 오른쪽 하단 고정 버튼
            AddPostButton(pViewModel: viewModel)
        }
    }
}

#Preview {
    PostsList(viewModel: PostsList.ViewModel())
}

