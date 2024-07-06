import Combine

class UserDashViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let postService = Service.Post()
    private let userService = Service.User()
    private let tokenManager = TokenManager()

    func loadInitialData() {
        Task {
            await loadBoardData()
            await loadMyAccountData()
        }
    }

    func refreshData() async {
        await loadBoardData()
        await loadMyAccountData()
    }

    private func loadBoardData() async {
        do {
            let posts = try await postService.fetchPosts()
            // Update your board view model with posts
        } catch {
            // Handle error
        }
    }

    private func loadMyAccountData() async {
        do {
            let user = try await userService.fetchUserDetails()
            // Update your my account view model with user details
        } catch {
            // Handle error
        }
    }
}
