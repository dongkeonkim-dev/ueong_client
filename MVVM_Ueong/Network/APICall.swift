//  APICall.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/26/24.
//
import Foundation

class APICall {
    static let shared = APICall()
    
    private init() {}
    
    func get<T: Decodable>(_ endpoint: String, parameters: [(String, Any)] = [], queryParameters: [String: Any] = [:]) async throws -> T {
        guard let result: T = try await request(endpoint: endpoint, method: .get, parameters: parameters, queryParameters: queryParameters) else {
            throw URLError(.badServerResponse)
        }
        return result
    }
    
    func post(_ endpoint: String,
                  parameters: [(String, Any)] = [],
                  queryParameters: [String: Any] = [:],
                  files: [File] = []) async throws -> Response {
        
        guard let result: Response = try await request(endpoint: endpoint, method: .post, parameters: parameters, queryParameters: queryParameters, files: files) else {
            throw URLError(.badServerResponse)
        }
        return result
    }
    
    func patch(_ endpoint: String,
                  parameters: [(String, Any)] = [],
                  queryParameters: [String: Any] = [:],
                  files: [File] = []) async throws -> Response {
        
        guard let result: Response = try await request(endpoint: endpoint, method: .patch, parameters: parameters, queryParameters: queryParameters, files: files) else {
            throw URLError(.badServerResponse)
        }
        return result
    }

    func delete(_ endpoint: String, queryParameters: [String: Any] = [:]) async throws -> VoidResult {
        guard let _: VoidResult = try await request(endpoint: endpoint, method: .delete, queryParameters: queryParameters) else {
            throw URLError(.badServerResponse)
        }
        return VoidResult()
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
            guard let requestURL = URL(string: "\(baseURL.joinPath(endpoint))") else {
                throw URLError(.badURL)
            }
            request = URLRequest(url: requestURL)
            request.httpMethod = method == .post ? "POST" : "PATCH"
            
            var bodyData = Data()
            
            if !files.isEmpty {
                let boundary = "Boundary-\(UUID().uuidString)"
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

                // 파라미터 추가
                for (key, value) in parameters {
                    bodyData.append("--\(boundary)\r\n")
                    bodyData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    bodyData.append("\(value)\r\n")
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
                print(bodyData)
            } else {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let jsonDict = Dictionary(uniqueKeysWithValues: parameters)
                let jsonData = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
                bodyData.append(jsonData)
                print(bodyData)
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

extension String {
    func joinPath(_ pathComponent: String) -> String {
        var result = self
        if result.hasSuffix("/") && pathComponent.hasPrefix("/") {
            result.removeLast()
        } else if !result.hasSuffix("/") && !pathComponent.hasPrefix("/") {
            result.append("/")
        }
        result.append(pathComponent)
        return result
    }
}

struct VoidResult: Decodable {
    var id = UUID()
}

struct File {
    var data: Data
    var fieldName: String
    var fileName: String
    var mimeType: String
}
