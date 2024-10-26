import SwiftUI



struct PostsList: View {
  @StateObject var viewModel = PostsList.ViewModel()
  
  var body: some View {
    ZStack {
      VStack(spacing: 20) {
        HStack(spacing: -15){
          SelectRegion(
            viewModel: viewModel,
            selection: $viewModel.selection,
            options: viewModel.myVillages,
            maxWidth: 130
          )
          .onChange(of: viewModel.selection) {
            Task{
              print("Region Changed")
              await viewModel.fetchPosts()
            }
          }
          SearchBar(viewModel: viewModel)
        }
        .zIndex(1)
        
        SelectPostOption(viewModel: viewModel)
        
        ScrollView {
          VStack(spacing: 13) {
            ForEach($viewModel.posts) { $post in
              NavigationLink(
                destination:
                  PostDetail(
                    viewModel: PostDetail.ViewModel(postId: post.id),
                    toggleFavorite: { toggledPost in
                      viewModel.toggleFavorite(post: toggledPost) // 좋아요 토글
                    }
                  )
              ) {
                PostRow(
                  post: $post,
                  toggleFavorite: { post in
                    viewModel.toggleFavorite(post: post)
                  },
                  inactivatePost: { post in
                    viewModel.inactivatePost(post: post)
                  },
                  refreshPostList: {
                    Task{
                      await viewModel.fetchPosts()
                    }
                  }
                )
              }
              
            }
          }
        }
        .refreshable {
          Task{ @MainActor in
            print("Refresh PostsList")
            await viewModel.fetchPosts() // 새로 고침 시 fetchPage 호출
          }
        }
      }
      
        // 오른쪽 하단 고정 버튼
      AddPostButton(viewModel: viewModel)
    }
  }
}

struct AddPostButton: View {
  @ObservedObject var viewModel: PostsList.ViewModel
  @State private var isNavigating = false // State to control navigation
  
  public var body: some View {
    ZStack {
      VStack {
        Spacer() // Push everything up
        HStack {
          Spacer()
          NavigationLink(
            destination: WritePost(
              emdId : viewModel.selection?.id ?? 0,
              postId: nil)
          ) {
            Image(systemName: "plus.circle.fill")
              .resizable()
              .frame(width: 50, height: 50)
              .foregroundColor(.blue)
              .padding()
          }
          .padding(.bottom, 20) // Bottom padding
          .padding(.trailing, 10) // Right padding
        }
      }
    }
  }
}

#Preview {
  PostsList()
}

