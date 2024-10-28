import SwiftUI



struct PostsList: View {
  @EnvironmentObject var appState : AppState
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
              PostRow(
                post: $post,
                togglePostsListFavorite: { post in
                  viewModel.togglePostsListFavorite(post: post)
                },
                inactivatePost: { post in
                  viewModel.inactivatePost(post: post)
                },
                refreshPostsList: {
                  Task{
                    await viewModel.fetchPosts()
                  }
                }
              )
            }
          }
          .onChange(of: viewModel.posts.count) {
            Task{
              await viewModel.fetchPhotosForPosts()
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
    .onChange(of: appState.isLoggedIn) { isLoggedIn in
      if isLoggedIn {
        Task{
          await viewModel.fetchVillageList()
          await viewModel.fetchPosts()
        }
      }
    }
  }
}

struct AddPostButton: View {
  @ObservedObject var viewModel: PostsList.ViewModel
  @State private var isNavigating = false // State to control navigation
  var refreshPostsList: () -> Void = {}
  
  public var body: some View {
    ZStack {
      VStack {
        Spacer() // Push everything up
        HStack {
          Spacer()
          NavigationLink(
            destination: WritePost(
              emdId : viewModel.selection?.id,
              postId: nil,
              addPostRow: viewModel.addPostRow,
              refreshPostsList: refreshPostsList
            )
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

