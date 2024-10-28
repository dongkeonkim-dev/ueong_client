import Foundation

class AuthRepository {
  func signup(username: String, password: String, email: String, nickname: String) async throws -> SignupResponse {
    let endpoint = "auth/signup"
    let parameters: [(String, Any)] = [
      ("username", username),
      ("password", password),
      ("email", email),
      ("nickname", nickname)
    ]
    let response: SignupResponse = try await APICall.shared.post(endpoint, parameters: parameters)
    return response
  }
  
  func login(username: String, password: String) async throws -> LoginResponse {
    let endpoint = "auth/login"
    let parameters: [(String, Any)] = [
      ("username", username),
      ("password", password)
    ]
    let response: LoginResponse = try await APICall.shared.post(endpoint, parameters: parameters)
    return response
  }
  
    /// 토큰을 검증하는 메서드
  func validateToken(accessToken: String) async throws -> ValidationResponse {
    let endpoint = "auth/validate-token"
    let response: ValidationResponse = try await APICall.shared.post(endpoint)
    return response
  }
}
