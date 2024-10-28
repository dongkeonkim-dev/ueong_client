import Foundation

@MainActor
class LoginViewModel: ObservableObject {
  @Published var username: String = ""
  @Published var password: String = ""
  @Published var isLoading: Bool = false
  @Published var loginSuccess: Bool = false
  @Published var errorMessage: String?
  var onLogin: (() -> Void)?
  
  private let authRepository: AuthRepository
  
    /// 이니셜라이저에서 의존성 주입을 통해 AuthRepository를 받습니다.
  init(authRepository: AuthRepository = AuthRepository()) {
    self.authRepository = authRepository
  }

  func login() async {
    guard !username.isEmpty, !password.isEmpty else {
      self.errorMessage = "사용자 이름과 비밀번호를 입력해주세요."
      return
    }
    isLoading = true
    errorMessage = nil
    do{
      let tokenResponse = try await authRepository.login(username: username, password: password)
      let success = UserDefaultsManager.shared.setUsername(username)
      TokenManager.shared.saveAccessToken(tokenResponse.accessToken, for: username)
      isLoading = false
      loginSuccess = true
    }catch{
      isLoading = false
    }
  }
}
