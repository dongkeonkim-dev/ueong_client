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
    
    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
      let responseString = String(data: data, encoding: .utf8) ?? "No response body"
      print("**** Server Error Response: \(responseString)")
      throw NSError(domain: "Server error", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: responseString])
    }
    
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
  
  func addHeaders(to request: inout URLRequest) throws {
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
//    if let headers = request.allHTTPHeaderFields {
//      print("**** HTTP Headers: \(headers)")
//    }
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

//
//import Foundation
//
//class APICall {
//  static let shared = APICall()
//  private let appState: AppState
//  
//  private init(appState: AppState = AppState()) {
//    self.appState = appState
//  }
//  
//  func get<T: Decodable>(
//    _ endpoint: String,
//    parameters: [(String, Any)] = [],
//    queryParameters: [String: Any] = [:]
//  ) async throws -> T {
//    guard let url = constructURL(endpoint: endpoint, queryParameters: queryParameters) else {
//      throw URLError(.badURL)
//    }
//    
//    var request = URLRequest(url: url)
//    request.httpMethod = "GET"
//    addHeaders(to: &request)
//    
//      // 추가 파라미터 처리 로직이 필요하면 여기에 작성
//    
//    let (data, response) = try await URLSession.shared.data(for: request)
//    return try decodeResponse(data: data, response: response)
//  }
//  
//  func post<T: Decodable>(
//    _ endpoint: String,
//    parameters: [(String, Any)] = [],
//    queryParameters: [String: Any] = [:],
//    files: [File] = []
//  ) async throws -> T {
//    guard let url = constructURL(endpoint: endpoint, queryParameters: queryParameters) else {
//      throw URLError(.badURL)
//    }
//    
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//    addHeaders(to: &request)
//    
//    if !files.isEmpty {
//      let boundary = UUID().uuidString
//      request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//      request.httpBody = try createMultipartBody(parameters: parameters, files: files, boundary: boundary)
//    } else {
//      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//      request.httpBody = try JSONSerialization.data(withJSONObject: dictFromParameters(parameters), options: [])
//    }
//    
//    let (data, response) = try await URLSession.shared.data(for: request)
//    return try decodeResponse(data: data, response: response)
//  }
//  
//    // PATCH, DELETE 등 다른 HTTP 메서드도 유사하게 구현
//  
//    /// URL을 구성하는 헬퍼 메서드
//  private func constructURL(endpoint: String, queryParameters: [String: Any]) -> URL? {
//    var urlString = baseURL.joinPath(endpoint)
//    if !queryParameters.isEmpty {
//      let query = queryParameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
//      urlString += "?\(query)"
//    }
//    return URL(string: urlString)
//  }
//  
//    /// 요청 헤더를 추가하는 헬퍼 메서드
//  private func addHeaders(to request: inout URLRequest) {
//    if let token = appState.userToken {
//      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//    }
//    if !appState.username.isEmpty {
//      request.setValue(appState.username, forHTTPHeaderField: "Username")
//    }
//  }
//  
//    /// 응답을 디코딩하는 헬퍼 메서드
//  private func decodeResponse<T: Decodable>(data: Data, response: URLResponse) throws -> T {
//    guard let httpResponse = response as? HTTPURLResponse,
//          (200...299).contains(httpResponse.statusCode) else {
//      let responseString = String(data: data, encoding: .utf8) ?? "No response body"
//      throw NSError(domain: "Server error", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: responseString])
//    }
//    
//    do {
//      let decodedData = try JSONDecoder().decode(T.self, from: data)
//      return decodedData
//    } catch {
//      throw error
//    }
//  }
//  
//    /// 파라미터를 딕셔너리로 변환하는 헬퍼 메서드
//  private func dictFromParameters(_ parameters: [(String, Any)]) -> [String: Any] {
//    var dict: [String: Any] = [:]
//    for (key, value) in parameters {
//      dict[key] = value
//    }
//    return dict
//  }
//  
//    /// 멀티파트 바디를 생성하는 헬퍼 메서드
//  private func createMultipartBody(parameters: [(String, Any)], files: [File], boundary: String) throws -> Data {
//    var body = Data()
//    
//    for (key, value) in parameters {
//      body.append("--\(boundary)\r\n".data(using: .utf8)!)
//      body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
//      body.append("\(value)\r\n".data(using: .utf8)!)
//    }
//    
//    for file in files {
//      body.append("--\(boundary)\r\n".data(using: .utf8)!)
//      body.append("Content-Disposition: form-data; name=\"\(file.fieldName)\"; filename=\"\(file.fileName)\"\r\n".data(using: .utf8)!)
//      body.append("Content-Type: \(file.mimeType)\r\n\r\n".data(using: .utf8)!)
//      body.append(file.data)
//      body.append("\r\n".data(using: .utf8)!)
//    }
//    
//    body.append("--\(boundary)--\r\n".data(using: .utf8)!)
//    
//    return body
//  }
//}
