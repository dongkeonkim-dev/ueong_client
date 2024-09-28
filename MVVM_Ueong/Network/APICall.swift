//  APICall.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/26/24.
//
import Foundation

class APICall {
    static let shared = APICall()
    
    private init() {}

    // 제네릭을 사용하여 다양한 타입에 대해 네트워크 요청을 보낼 수 있는 함수
    func get<T: Decodable>(_ endpoint: String, parameters: [String: Any], queryParameters: [String: Any] = [:], completion: @escaping (Result<T, Error>) -> Void) {
        
        var endpointWithParams = endpoint
        
        // 일반 파라미터 추가
        for (key, value) in parameters {
            if let stringValue = value as? String, !stringValue.isEmpty {
                endpointWithParams += "/\(stringValue)"
            } else if let intValue = value as? Int {
                endpointWithParams += "/\(intValue)"
            }
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
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            // 받은 데이터를 콘솔에 출력
            if let jsonString = String(data: data, encoding: .utf8) {
                print("****Response JSON String: \(jsonString)\n")
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
