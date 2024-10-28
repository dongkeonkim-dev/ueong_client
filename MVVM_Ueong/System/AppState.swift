import Foundation
import Combine

final class AppState: ObservableObject {
  
  @Published var isLoggedIn: Bool = false
  
  private let userDefaultsManager: UserDefaultsManager
  private let authRepository: AuthRepository
  private let tokenManager: TokenManager
  
  init(userDefaultsManager: UserDefaultsManager = UserDefaultsManager.shared,
       authRepository: AuthRepository = AuthRepository(),
       tokenManager: TokenManager = TokenManager.shared) {
    self.userDefaultsManager = userDefaultsManager
    self.authRepository = authRepository
    self.tokenManager = tokenManager
    
    initializeAppState()
  }
  
  private func initializeAppState() {
    print("initializeAppState: 사용자 이름 가져오기 시도")
    
    guard let username = userDefaultsManager.getUsername() else {
      print("initializeAppState: 마지막 사용자 이름이 존재하지 않습니다.")
      return
    }
    
    fetchAccessToken(for: username)
  }
  
  private func fetchAccessToken(for username: String) {
    guard let accessToken = tokenManager.getAccessToken(for: username) else {
      print("fetchAccessToken: 사용자 '\(username)'의 액세스 토큰이 존재하지 않습니다.")
      return
    }
    validateAccessToken(accessToken)
  }
  
  func validateAccessToken(_ accessToken: String) {
    Task {
      do {
        let validationResponse : ValidationResponse = try await authRepository.validateToken(accessToken: accessToken)
        handleValidationResponse(validationResponse)
      } catch {
        handleValidationError(error)
      }
    }
  }
  
  private func handleValidationResponse(_ response: ValidationResponse) {
    DispatchQueue.main.async { [weak self] in
      self?.isLoggedIn = response.isValid
      print("handleValidationResponse: 토큰 검증 성공 - isLoggedIn: \(response.isValid)")
    }
  }
  
  private func handleValidationError(_ error: Error) {
    DispatchQueue.main.async { [weak self] in
      self?.isLoggedIn = false
      print("handleValidationError: 토큰 검증 실패 - error: \(error.localizedDescription)")
    }
  }
}