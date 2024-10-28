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
  private let appState: AppState
  
    /// 이니셜라이저에서 의존성 주입을 통해 AuthRepository와 AppState를 받습니다.
  init(authRepository: AuthRepository = AuthRepository(),
       appState: AppState = AppState()) {
    self.authRepository = authRepository
    self.appState = appState
  }
  
  func signup() async {
    guard password == confirmPassword else {
      self.errorMessage = "비밀번호가 일치하지 않습니다."
      return
    }
    
    isLoading = true
    errorMessage = nil
    
    do {
      let signupResponse = try await authRepository.signup(username: username, password: password, email: email, nickname: nickname)
      self.signupSuccess = true
    } catch let error as AuthError {
      self.errorMessage = error.localizedDescription
    } catch {
      self.errorMessage = "회원가입에 실패했습니다: \(error.localizedDescription)"
    }
    
    isLoading = false
  }
}
