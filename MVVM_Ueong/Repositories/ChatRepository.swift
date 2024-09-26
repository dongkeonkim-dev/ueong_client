//
//  ChatRepository.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//

import Foundation

class ChatRepository {
    func getChatsByUsername(username: String, completion: @escaping (Result<[Chat], Error>) -> Void) {
        // API 호출을 통해 chats 데이터를 받아오는 로직
        APICall.shared.get("chat/by-username", parameters: ["username": username]) { (result: Result<[Chat], Error>) in
            switch result {
            case .success(var chats):
                let dateFormatter = ISO8601DateFormatter()
                dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

                // 받은 chats 데이터를 처리
                for i in 0..<chats.count {
                    // rawlastSentTime을 Date로 변환
                    if let date = dateFormatter.date(from: chats[i].rawlastSentTime) {
                        chats[i].lastSentTime = date
                    }

                    // chatter 설정: senderUsername과 receiverUsername 중 username과 다른 것을 chatter로 설정
                    if chats[i].senderUsername == username {
                        chats[i].chatterUsername = chats[i].receiverUsername
                        chats[i].chatterNickname = chats[i].receiverNickname
                        
                    } else {
                        chats[i].chatterUsername = chats[i].senderUsername
                        chats[i].chatterNickname = chats[i].senderNickname
                    }
                }

                // 결과를 completion으로 반환
                completion(.success(chats))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
