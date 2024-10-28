import Foundation

final class TokenManager {
  static let shared = TokenManager()
  
  private init() {}
  
    /// Access Token 가져오기
    /// - Parameter username: 사용자 이름
    /// - Returns: 접근 토큰 문자열 또는 `nil`
  func getAccessToken(for username: String) -> String? {
    //print("TokenManager: getAccessToken 호출 - username = \(username)")
    if let data = KeychainHelper.shared.read(service: Constants.Keychain.accessToken, account: username) {
      let token = String(data: data, encoding: .utf8)
      //print("TokenManager: 토큰 로드 성공 - token = \(token ?? "nil")")
      return token
    } else {
      //print("TokenManager: 토큰 로드 실패 - 데이터 없음")
      return nil
    }
  }
  
    /// Access Token 저장
    /// - Parameters:
    ///   - token: 저장할 접근 토큰
    ///   - username: 사용자 이름
    /// - Returns: 저장 성공 여부
  @discardableResult
  func saveAccessToken(_ token: String, for username: String) -> Bool {
    //print("TokenManager: saveAccessToken 호출 - username = \(username), token = \(token)")
    guard let data = token.data(using: .utf8) else {
      //print("TokenManager: 토큰 데이터를 UTF-8로 인코딩하는 데 실패했습니다.")
      return false
    }
    let success = KeychainHelper.shared.save(data, service: Constants.Keychain.accessToken, account: username)
    if success {
      //print("TokenManager: 토큰 저장 성공")
    } else {
      //print("TokenManager: 토큰 저장 실패")
    }
    return success
  }
  
    /// 모든 토큰 삭제
    /// - Parameter username: 사용자 이름
    /// - Returns: 삭제 성공 여부
  @discardableResult
  func clearTokens(for username: String) -> Bool {
    //print("TokenManager: clearTokens 호출 - username = \(username)")
    let success = KeychainHelper.shared.delete(service: Constants.Keychain.accessToken, account: username)
    if success {
      //print("TokenManager: 토큰 삭제 성공")
    } else {
      //print("TokenManager: 토큰 삭제 실패")
    }
    return success
  }
}
