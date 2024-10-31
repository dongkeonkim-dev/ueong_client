import Foundation

@MainActor
class SignupViewModel: ObservableObject {
  @Published var username: String = ""
  @Published var password: String = ""
  @Published var confirmPassword: String = ""
  @Published var email: String = ""
  @Published var nickname: String = ""
  @Published var isLoading: Bool = false
  @Published var signupSuccess: Bool = false
  @Published var errorMessage: String?
  
  private let authRepository: AuthRepository
  
    /// 이니셜라이저에서 의존성 주입을 통해 AuthRepository와 AppState를 받습니다.
  init(authRepository: AuthRepository = AuthRepository()) {
    self.authRepository = authRepository
  }
  
  func signup() async {
    guard password == confirmPassword else {
      self.errorMessage = "비밀번호가 일치하지 않습니다."
      return
    }
    
    isLoading = true
    errorMessage = nil
    
    do {
      let tokenResponse = try await authRepository.signup(username: username, password: password, email: email, nickname: nickname)
      let success = UserDefaultsManager.shared.setUsername(username)
      TokenManager.shared.saveAccessToken(tokenResponse.accessToken, for: username)
      isLoading = false
      signupSuccess = true
    }catch{
      isLoading = false
    }
  }
}
