//Rootview.swift
import SwiftUI
import Combine


// MARK: - View
struct RootView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    @State private var isLoading: Bool = true
    @State private var authStatus: AuthStatus? = nil
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading...")
            } else {
                switch authStatus {
                case .loggedIn(let role):
                    switch role {
                    case .admin:
                        viewModel.routingState.adminDash()
                    case .user:
                        viewModel.routingState.userDash()
                    }
                case .loggedOut:
                    viewModel.routingState.login()
                case .none:
                    EmptyView()
                }
            }
        }
        .onAppear {
            checkAuthStatus()
        }
    }
    
    private func checkAuthStatus() {
        Task {
            authStatus = await viewModel.checkRole()
            isLoading = false
        }
    }
}

// MARK: - Routing
private extension RootView {
    func adminDash() -> some View {
        AdminDashView(viewModel: .init(container: viewModel.container))
    }
    
    func userDash() -> some View {
        UserDashView(viewModel: .init(container: viewModel.container))
    }
    
    func login() -> some View {
        LoginView(viewModel: .init(container: viewModel.container))
    }
}


// MARK: - ViewModel
extension RootView {
    class ViewModel: ObservableObject {
        
        // State
        @Published var routingState: Routing
        
        let container: DIContainer
        private var cancelBag = CancelBag()
        
        init(container: DIContainer) {
            self.container = container
        }
        
        func checkRole() async -> AuthStatus {
            // Keychain에서 토큰을 가져와 webRepository로 보내 로그인 상태를 확인하는 로직
            guard let token = Keychain.getToken() else {
                return .loggedOut
            }
            do {
                let role = try await container.services.webRepository.checkRole(token: token)
                return .loggedIn(role: role)
            } catch {
                return .loggedOut
            }
        }
    }
}
