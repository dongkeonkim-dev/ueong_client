//
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
    func get<T: Decodable>(_ endpoint: String, parameters: [String: Any], completion: @escaping (Result<T, Error>) -> Void) {
        // username과 chatter 파라미터를 가져옴
        guard let username = parameters["username"] as? String else {
            completion(.failure(NSError(domain: "Invalid parameters", code: 0, userInfo: nil)))
            return
        }

        // 기본 엔드포인트
        var endpointWithParams = "\(endpoint)/\(username)"

        // chatter 파라미터가 있을 경우 추가
        if let chatter = parameters["chatter"] as? String {
            endpointWithParams += "/\(chatter)"
        }
        
        // URL 생성
        guard let url = URL(string: "http://localhost:3000/\(endpointWithParams)") else {
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
                print("Response JSON String: \(jsonString)")
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
