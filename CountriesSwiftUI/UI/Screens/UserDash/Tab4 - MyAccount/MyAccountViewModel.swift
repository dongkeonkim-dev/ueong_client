import Combine

@MainActor
class MyAccountViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let userService = UserService()

    @Published var user: UserModel?

    func loadData() {
        Task {
            await fetchUserDetails()
        }
    }

    func refreshData() async {
        await fetchUserDetails()
    }

    private func fetchUserDetails() async {
        do {
            let user = try await userService.fetchUserDetails()
            self.user = user
        } catch {
            // Handle error
        }
    }
}
