//import XCoordinator
//import SwiftUI
//
//enum AccountEditRoute: Route {
//    case accountEdit
//}
//
//class AccountEditCoordinator: NavigationCoordinator<AccountEditRoute> {
//    init() {
//        super.init(initialRoute: .accountEdit)
//    }
//
//    override func prepareTransition(for route: AccountEditRoute) -> NavigationTransition {
//        switch route {
//        case .accountEdit:
//            let accountEditViewModel = AccountEditViewModel()
//            return .push(AccountEditView(viewModel: accountEditViewModel))
//        }
//    }
//}
