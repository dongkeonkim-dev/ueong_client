//import Combine
//
//class AccountEditViewModel: ObservableObject {
//    private var cancellables = Set<AnyCancellable>()
//    private let userService = UserService()
//
//    @Published var userDetails: UserModel?
//
//    func loadData() {
//        Task {
//            await fetchUserDetails()
//        }
//    }
//
//    private func fetchUserDetails() async {
//        do {
//            let userDetails = try await userService.fetchUserDetails()
//            DispatchQueue.main.async {
//                self.userDetails = userDetails
//            }
//        } catch {
//            // Handle error
//        }
//    }
//}
