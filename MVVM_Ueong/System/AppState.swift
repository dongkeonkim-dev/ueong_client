import Foundation

final class AppState: ObservableObject {
  
  @Published var isLoggedIn: Bool = false
  
  private let userDefaultsManager: UserDefaultsManager
  private let authRepository: AuthRepository
  private let tokenManager: TokenManager
  
  init(
    userDefaultsManager: UserDefaultsManager = UserDefaultsManager.shared,
    authRepository: AuthRepository = AuthRepository(),
    tokenManager: TokenManager = TokenManager.shared)
  {
    self.userDefaultsManager = userDefaultsManager
    self.authRepository = authRepository
    self.tokenManager = tokenManager
    
    autoLogin()
  }

  // MARK: - initialize
  private func autoLogin() {
    // 사용자 이름 가져오기
    guard let username = userDefaultsManager.getUsername() else {
      print("initializeAppState: 마지막 사용자 이름이 존재하지 않습니다.")
      return
    }
    
    // 엑세스 토큰 가져오기
    guard let accessToken = tokenManager.getAccessToken(for: username) else {
      print("fetchAccessToken: 사용자 '\(username)'의 액세스 토큰이 존재하지 않습니다.")
      return
    }
    
    // 엑세스 토큰 검증
    login(accessToken)
  }
  
    //MARK: - public func
  func setLoggedIn(_ loggedIn: Bool) {
    self.isLoggedIn = loggedIn
  }
  
  func login(_ accessToken: String) {
    Task {
      do {
        let validationResponse : ValidationResponse = try await authRepository.validateToken(accessToken: accessToken)
        handleValid(validationResponse)
      } catch {
        handleInvalid(error)
      }
    }
  }
  
  //MARK: - private func
  private func handleValid(_ response: ValidationResponse) {
    DispatchQueue.main.async { [weak self] in
      self?.setLoggedIn(response.isValid)
      print("handleValidationResponse: 토큰 검증 성공 - isLoggedIn: \(response.isValid)")
    }
  }
  
  private func handleInvalid(_ error: Error) {
    DispatchQueue.main.async { [weak self] in
      self?.setLoggedIn(false)
      print("handleValidationError: 토큰 검증 실패 - error: \(error.localizedDescription)")
    }
  }
}
