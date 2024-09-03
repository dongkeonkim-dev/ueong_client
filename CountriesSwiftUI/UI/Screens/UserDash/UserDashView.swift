//import SwiftUI
//
//struct UserDashView: View {
//    @StateObject var viewModel = UserDashViewModel()
//    
//    var body: some View {
//        TabView {
//            BoardView(viewModel: BoardViewModel())
//                .tabItem {
//                    Image(systemName: "house")
//                    Text("홈")
//                }
//            ChatsView(viewModel: ChatsViewModel())
//                .tabItem {
//                    Image(systemName: "bubble.right")
//                    Text("채팅")
//                }
//            FavoritesView(viewModel: FavoritesViewModel())
//                .tabItem {
//                    Image(systemName: "heart")
//                    Text("좋아요")
//                }
//            MyAccountView(viewModel: MyAccountViewModel())
//                .tabItem {
//                    Image(systemName: "person")
//                    Text("내정보")
//                }
//        }
//        .navigationBarHidden(true)
//        .onAppear {
//            viewModel.loadInitialData()
//        }
//        .refreshable {
//            await viewModel.refreshData()
//        }
//    }
//}
