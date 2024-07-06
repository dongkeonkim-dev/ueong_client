import Combine

@MainActor
class BoardViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let postService = Service.Post()

    @Published var posts: [Post] = []

    func loadData() {
        Task {
            await fetchPosts()
        }
    }

    func refreshData() async {
        await fetchPosts()
    }

    private func fetchPosts() async {
        do {
            let posts = try await postService.fetchPosts()
            self.posts = posts
        } catch {
            // Handle error
        }
    }
}
