    //  APICall.swift
    //  MVVM_Ueong
    //
    //  Created by 김동건 on 9/26/24.
    //
    import Foundation


class APICall {
  static let shared = APICall()
  let userDefaultsManager = UserDefaultsManager.shared
  let tokenManager = TokenManager.shared
  
  
  func get<T: Decodable>(
    _ endpoint: String,
    parameters: [(String, Any)] = [],
    queryParameters: [String: Any] = [:]
  ) async throws -> T {
    guard
      let result: T = try await
        request(
          endpoint: endpoint,
          method: .get,
          parameters: parameters,
          queryParameters: queryParameters
        )
    else {throw URLError(.badServerResponse)}
    return result
  }
  
  func post<T: Decodable>(
    _ endpoint: String,
    parameters: [(String, Any)] = [],
    queryParameters: [String: Any] = [:],
    files: [File] = []
  ) async throws -> T {
    
    guard
      let result: T = try await
        request(
          endpoint: endpoint,
          method: .post,
          parameters: parameters,
          queryParameters: queryParameters,
          files: files
        )
    else { throw URLError(.badServerResponse) }
    return result
  }
  
  func patch(
    _ endpoint: String,
    parameters: [(String, Any)] = [],
    queryParameters: [String: Any] = [:],
    files: [File] = []
  ) async throws -> Response {
    
    guard
      let result: Response = try await
        request(
          endpoint: endpoint,
          method: .patch,
          parameters: parameters,
          queryParameters: queryParameters,
          files: files)
    else { throw URLError(.badServerResponse) }
    return result
  }
  
  func delete(
    _ endpoint: String,
    queryParameters: [String: Any] = [:]
  ) async throws -> Response {
    guard
      let response: Response = try await
        request(
          endpoint: endpoint,
          method: .delete,
          queryParameters: queryParameters
        )
    else { throw URLError(.badServerResponse) }
    return response
  }
  
  func request<T: Decodable>(
    endpoint: String,
    method: Method,
    parameters: [(String, Any)] = [],
    queryParameters: [String: Any] = [:],
    files: [File] = []
  ) async throws -> T? {
    
    var request = URLRequest(url: URL(string: "\(baseURL)")!)
    
    switch method {
      case .post, .patch:
        guard
          let requestURL =
            URL(string: "\(baseURL.joinPath(endpoint))")
        else { throw URLError(.badURL) }
        request = URLRequest(url: requestURL)
        request.httpMethod = method == 
          .post ? "POST" : "PATCH"
        var bodyData = Data()
        
        //파일이 있는 경우
        if !files.isEmpty {
          let boundary = "Boundary-\(UUID().uuidString)"
          request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
          
            // 파라미터 추가
          for (key, value) in parameters {
            let unwrappedValue = unwrapOptional(value) // Optional 값 처리
            bodyData.append("--\(boundary)\r\n")
            bodyData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            bodyData.append("\(unwrappedValue)\r\n")
          }
          
            // 파일 데이터 추가
          for file in files {
            bodyData.append("--\(boundary)\r\n")
            bodyData.append("Content-Disposition: form-data; name=\"\(file.fieldName)\"; filename=\"\(file.fileName)\"\r\n")
            bodyData.append("Content-Type: \(file.mimeType)\r\n\r\n")
            bodyData.append(file.data)
            bodyData.append("\r\n")
          }
          bodyData.append("--\(boundary)--\r\n")
          
        //파일이 없는 경우
        } else {
          request.setValue("application/json", forHTTPHeaderField: "Content-Type")
          let jsonDict = Dictionary(uniqueKeysWithValues: parameters)
          let jsonData = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
          bodyData.append(jsonData)
        }
        request.httpBody = bodyData
        
        let bodyString = String(data: bodyData, encoding: .utf8)
        
        if let bodyString = bodyString {
          print("HTTP Body: \(bodyString)")
        } else {
          print("HTTP Body is empty or cannot be converted to string")
        }
        
      case .get:
        var paramString = parameters.map { $0.0.joinPath(String(describing: $0.1)) }.reduce("") { $0.joinPath($1) }
        var urlComponents = URLComponents(string: "\(baseURL.joinPath(endpoint).joinPath(paramString))")
        
        if !queryParameters.isEmpty {
          var queryItems: [URLQueryItem] = []
          for (key, value) in queryParameters {
            queryItems.append(URLQueryItem(name: key, value: "\(value)"))
          }
          urlComponents?.queryItems = queryItems
        }
        
        guard let url = urlComponents?.url else {
          throw URLError(.badURL)
        }
        request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
      case .delete:
        var urlComponents = URLComponents(string: "\(baseURL.joinPath(endpoint))")
        if !queryParameters.isEmpty {
          urlComponents?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        guard let url = urlComponents?.url else {
          throw URLError(.badURL)
        }
        request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    do {
      try addHeaders(to: &request)
    } catch {
      print("헤더 추가 중 에러 발생: \(error)")
      throw error
    }
    
    print("HTTP Method:", request.httpMethod ?? "nil", "URL:", request.url?.absoluteString ?? "nil")
    
      // 네트워크 요청 수행
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw URLError(.badServerResponse)
    }
    
    try handleHTTPStatusCode(httpResponse.statusCode, responseData: data)
    
      // JSON 응답을 출력
    if let jsonResponse = String(data: data, encoding: .utf8) {
      print("**** Response JSON: \(jsonResponse)")
      do {
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        print("**** Decoded Data: \(decodedData)")
        return decodedData
      } catch {
        print("Error decoding data: \(error)")
        throw error
      }
    }
    return nil
  }
  
    /// HTTP 상태 코드를 처리하는 함수
    /// - Parameter statusCode: HTTP 응답 상태 코드
    /// - Returns: 정상 응답인 경우 void
    /// - Throws: 상태 코드에 따른 에러
  private func handleHTTPStatusCode(_ statusCode: Int, responseData: Data) throws {
    print("statusCode: ",statusCode)
    switch statusCode {
      case 200...399:
          // 성공 응답 처리
        return // JSON 디코딩으로 진행
        
      case 401:
          // 응답 데이터에서 메시지 추출
        if let errorResponse = try? JSONDecoder().decode(MessageResponse.self, from: responseData) {
          NotificationCenter.default.post(
            name: .tokenExpired,
            object: nil,
            userInfo: ["message": errorResponse.message]
          )
        }
        throw AuthError.invalidToken
        
      case 400...599:
          // 서버 오류 처리
        NotificationCenter.default.post(
          name: .init(rawValue: "\(statusCode)"),
          object: nil,
          userInfo: ["message": "\(statusCode) 에러"]
        )
      default:
        return
    }
  }
  
  
  private func addHeaders(to request: inout URLRequest) throws {
    guard let username = userDefaultsManager.getUsername() else {
      print("사용자 이름을 가져올 수 없습니다.")
      return
    }
    
    guard let token = tokenManager.getAccessToken(for: username) else {
      print("토큰을 가져올 수 없습니다.")
      return
    }
    
    //토큰 추가
    request.setValue("Bearer \(token)", forHTTPHeaderField: Constants.accessTokenHeader)
  }
}

    // Helper Extensions and Enums
extension Data {
  mutating func append(_ string: String) {
    if let data = string.data(using: .utf8) {
      append(data)
    }
  }
}

enum Method {
  case post
  case get
  case delete
  case patch
}

struct File {
  var data: Data
  var fieldName: String
  var fileName: String
  var mimeType: String
}

func unwrapOptional(_ value: Any) -> String {
  if let optionalValue = value as? AnyOptional, let unwrapped = optionalValue.optionalValue {
    return "\(unwrapped)" // Optional 값을 안전하게 언래핑
  }
  return "\(value)" // Optional이 아니면 그대로 문자열로 변환
}

    // Optional 타입을 처리하기 위한 프로토콜 정의
protocol AnyOptional {
  var optionalValue: Any? { get }
}

extension Optional: AnyOptional {
  var optionalValue: Any? { return self }
}
