import Foundation

class AuthRepository {
  func signup(username: String, password: String, email: String, nickname: String) async throws -> TokenResponse {
    let endpoint = "auth/signup"
    let parameters: [(String, Any)] = [
      ("username", username),
      ("password", password),
      ("email", email),
      ("nickname", nickname)
    ]
    let response: TokenResponse = try await APICall.shared.post(endpoint, parameters: parameters)
    return response
  }
  
  func login(username: String, password: String) async throws -> TokenResponse {
    let endpoint = "auth/login"
    let parameters: [(String, Any)] = [
      ("username", username),
      ("password", password)
    ]
    let response: TokenResponse = try await APICall.shared.post(endpoint, parameters: parameters)
    return response
  }
  
    /// 토큰을 검증하는 메서드
  func validateToken(accessToken: String) async throws -> ValidationResponse {
    let endpoint = "auth/validate-token"
    let response: ValidationResponse = try await APICall.shared.post(endpoint)
    return response
  }
}
