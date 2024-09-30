//
//  ChatRepository.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//
import Foundation

class ChatRepository {
    // 비동기 함수로 사용자 이름에 따른 채팅 목록을 가져오기
    func getChatsByUsername(username: String) async throws -> [Chat] {
        // API 호출을 통해 chats 데이터를 받아오는 로직
        var chats: [Chat] = try await APICall.shared.get("chat/by-username", parameters: [username])

        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        // 받은 chats 데이터를 처리
        for i in 0..<chats.count {
            // rawlastSentTime을 Date로 변환
            if let date = dateFormatter.date(from: chats[i].rawlastSentTime) {
                chats[i].lastSentTime = date
            }

            // chatter 설정: sellerUsername과 buyerUsername 중 username과 다른 것을 chatter로 설정
            if chats[i].sellerUsername == username {
                chats[i].chatterUsername = chats[i].buyerUsername
                chats[i].chatterNickname = chats[i].buyerNickname
            } else {
                chats[i].chatterUsername = chats[i].sellerUsername
                chats[i].chatterNickname = chats[i].sellerNickname
            }
        }

        return chats
    }
}
