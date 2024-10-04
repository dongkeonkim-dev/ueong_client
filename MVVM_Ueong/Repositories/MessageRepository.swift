//
//  MessageRepository.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//
import Foundation

class MessageRepository {
    // 비동기 함수로 채팅 상대방에 따른 메시지 목록 가져오기
    func getMessagesByChatter(username: String, chatter: String) async throws -> [Message] {
        do {
            let messages: [Message] = try await APICall.shared.get("message", parameters: [("username",username)], queryParameters:["chatter":chatter] )
            return messages
        } catch {
            print("Error fetching messages: \(error)")
            throw error
        }
    }
}
