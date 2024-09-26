//
//  MessageRepository.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//
import Foundation


class MessageRepository {
    func getMessagesByChatter(username: String, chatter: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        // APICall을 통해 서버에서 메시지를 받아옴
        APICall.shared.get("message/by-chatter", parameters: ["username": username, "chatter": chatter]) { (result: Result<[Message], Error>) in
            switch result {
            case .success(let messages):
                completion(.success(messages))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

