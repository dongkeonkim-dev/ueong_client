import Foundation
import Security

final class KeychainHelper {
  static let shared = KeychainHelper()
  
  private init() {}
  
    /// 데이터를 Keychain에 저장합니다.
    /// - Parameters:
    ///   - data: 저장할 데이터
    ///   - service: 서비스 이름
    ///   - account: 계정 이름
    /// - Returns: 저장 성공 여부
  func save(_ data: Data, service: String, account: String) -> Bool {
    print("KeychainHelper: save 호출 - service = \(service), account = \(account)")
    
      // 기존 키체인 항목 삭제
    let query = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account
    ] as [String: Any]
    
    let deleteStatus = SecItemDelete(query as CFDictionary)
    if deleteStatus == errSecSuccess {
      print("KeychainHelper: 기존 키체인 항목 삭제 성공")
    } else if deleteStatus != errSecItemNotFound {
      print("KeychainHelper: 기존 키체인 항목 삭제 실패 - 상태 코드: \(deleteStatus)")
      return false
    } else {
      print("KeychainHelper: 기존 키체인 항목 없음, 새로 저장 시도")
    }
    
      // 새 키체인 항목 추가
    var attributes: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
      kSecValueData as String: data
    ]
    
      // Access Group이 필요한 경우 추가
      // attributes[kSecAttrAccessGroup as String] = Constants.Keychain.accessGroup
    
    let status = SecItemAdd(attributes as CFDictionary, nil)
    
    if status == errSecSuccess {
      print("KeychainHelper: 키체인에 데이터 저장 성공")
      return true
    } else {
      print("KeychainHelper: 키체인에 데이터 저장 실패 - 상태 코드: \(status)")
      return false
    }
  }
  
    /// Keychain에서 데이터를 읽어옵니다.
    /// - Parameters:
    ///   - service: 서비스 이름
    ///   - account: 계정 이름
    /// - Returns: 저장된 데이터 또는 `nil`
  func read(service: String, account: String) -> Data? {
    print("KeychainHelper: read 호출 - service = \(service), account = \(account)")
    let query = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne
    ] as [String: Any]
    
    var item: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    
    if status == errSecSuccess {
      print("KeychainHelper: 키체인에서 데이터 읽기 성공")
      return item as? Data
    } else if status == errSecItemNotFound {
      print("KeychainHelper: 키체인 항목이 존재하지 않습니다 - 상태 코드: \(status)")
      return nil
    } else {
      print("KeychainHelper: 키체인 데이터 읽기 실패 - 상태 코드: \(status)")
      return nil
    }
  }
  
    /// Keychain에서 데이터를 삭제합니다.
    /// - Parameters:
    ///   - service: 서비스 이름
    ///   - account: 계정 이름
    /// - Returns: 삭제 성공 여부
  func delete(service: String, account: String) -> Bool {
    print("KeychainHelper: delete 호출 - service = \(service), account = \(account)")
    let query = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account
    ] as [String: Any]
    
    let status = SecItemDelete(query as CFDictionary)
    
    if status == errSecSuccess {
      print("KeychainHelper: 키체인 항목 삭제 성공")
      return true
    } else if status == errSecItemNotFound {
      print("KeychainHelper: 키체인 항목이 존재하지 않음 - 상태 코드: \(status)")
      return true // 항목이 없으면 삭제 완료로 간주
    } else {
      print("KeychainHelper: 키체인 항목 삭제 실패 - 상태 코드: \(status)")
      return false
    }
  }
}
