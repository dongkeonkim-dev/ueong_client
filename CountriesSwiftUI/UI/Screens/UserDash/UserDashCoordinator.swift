//import XCoordinator
//import SwiftUI
//
//enum UserDashRoute: Route {
//    case board
//    case chats
//    case favorites
//    case myAccount
//    case accountEdit
//}
//
//class UserDashCoordinator: NavigationCoordinator<UserDashRoute> {
//    init(router: AnyRouter<UserDashRoute>) {
//        super.init(initialRoute: .board)
//    }
//
//    override func prepareTransition(for route: UserDashRoute) -> NavigationTransition {
//        switch route {
//        case .board:
//            let boardViewModel = BoardViewModel()
//            return .push(BoardView(viewModel: boardViewModel))
//        case .chats:
//            let chatsViewModel = ChatsViewModel()
//            return .push(ChatsView(viewModel: chatsViewModel))
//        case .favorites:
//            let favoritesViewModel = FavoritesViewModel()
//            return .push(FavoritesView(viewModel: favoritesViewModel))
//        case .myAccount:
//            let myAccountViewModel = MyAccountViewModel()
//            return .push(MyAccountView(viewModel: myAccountViewModel))
//        case .accountEdit:
//            let accountEditViewModel = AccountEditViewModel()
//            return .push(AccountEditView(viewModel: accountEditViewModel))
//        }
//    }
//}
