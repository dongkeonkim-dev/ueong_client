import Foundation

  /// UserDefaults에 접근하는 매니저 클래스
final class UserDefaultsManager {
  static let shared = UserDefaultsManager()
  private let userDefaults: UserDefaults
  
  private init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
  }
  
    /// 동기적으로 username을 가져옵니다.
    /// - Returns: 사용자 이름 또는 `nil`
  func getUsername() -> String? {
    let username = userDefaults.string(forKey: "username")
    //print("username을 가져옵니다. \(username ?? "")")
    return username
  }
  
    /// 동기적으로 username을 저장합니다.
    /// - Parameter username: 저장할 사용자 이름
    /// - Returns: 저장 성공 여부
  func setUsername(_ username: String) -> Bool {
    //print("username을 저장합니다. \(username)")
    userDefaults.set(username, forKey: "username")
    return userDefaults.synchronize()
  }
}
