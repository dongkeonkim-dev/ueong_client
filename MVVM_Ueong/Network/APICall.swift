//  APICall.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/26/24.
//
import Foundation

class APICall {
    static let shared = APICall()
    
    private init() {}

    // 요청 (`GET` 요청의 경우 사용) - body가 필요 없는 경우
    func request<U: Decodable>(endpoint: String, method: String = "GET", parameters: [Any] = [], queryParameters: [String: Any] = [:]) async throws -> U {
    
        // 일반 파라미터 추가 (URL 경로의 파라미터)
        var endpointWithParams = endpoint
        for value in parameters {
            endpointWithParams += "/\(value)"
        }
        
        // 쿼리 파라미터 추가
        var queryItems: [URLQueryItem] = []
        for (key, value) in queryParameters {
            if let stringValue = value as? String {
                queryItems.append(URLQueryItem(name: key, value: stringValue))
            }
        }
        
        // URL 생성
        var urlComponents = URLComponents(string: "\(baseURL)\(endpointWithParams)")
        if !queryItems.isEmpty {
            urlComponents?.queryItems = queryItems
        }
        
        guard let url = urlComponents?.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // 네트워크 요청 수행
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let responseString = String(data: data, encoding: .utf8) ?? "No response body"
            throw NSError(domain: "Server error", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: responseString])
        }

        // JSON 응답을 출력
        if let jsonResponse = String(data: data, encoding: .utf8) {
            print("**** Response JSON: \(jsonResponse)")
        }

        do {
            let decodedData = try JSONDecoder().decode(U.self, from: data)
            print("**** Decoded Data: \(decodedData)") // 디코딩된 데이터를 출력합니다.
            return decodedData
        } catch {
            throw error
        }
    }

    // 요청 (`POST` 요청 등 body가 필요한 경우 사용) - 반환이 없는 경우
    func request<T: Encodable>(endpoint: String, method: String, parameters: [Any] = [], queryParameters: [String: Any] = [:], body: T) async throws {

        // 일반 파라미터 추가 (URL 경로의 파라미터)
        var endpointWithParams = endpoint
        for value in parameters {
            endpointWithParams += "/\(value)"
        }

        // 쿼리 파라미터 추가
        var queryItems: [URLQueryItem] = []
        for (key, value) in queryParameters {
            if let stringValue = value as? String {
                queryItems.append(URLQueryItem(name: key, value: stringValue))
            }
        }

        // URL 생성
        var urlComponents = URLComponents(string: "\(baseURL)\(endpointWithParams)")
        if !queryItems.isEmpty {
            urlComponents?.queryItems = queryItems
        }

        guard let url = urlComponents?.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // POST 또는 PUT의 경우 body 추가
        do {
            let jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData
        } catch {
            throw error
        }

        // 네트워크 요청 수행
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        // JSON 응답을 출력
        if let jsonResponse = String(data: data, encoding: .utf8) {
            print("**** Response JSON: \(jsonResponse)")
        }
        
    }

    // GET 메서드
    func get<U: Decodable>(_ endpoint: String, parameters: [Any] = [], queryParameters: [String: Any] = [:]) async throws -> U {
        return try await request(endpoint: endpoint, method: "GET", parameters: parameters, queryParameters: queryParameters)
    }

    // POST 메서드
    func post<T: Encodable>(_ endpoint: String, body: T) async throws {
        try await request(endpoint: endpoint, method: "POST", body: body)
    }
}
