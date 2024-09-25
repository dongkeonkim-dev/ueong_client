//
//  ChatRepository.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//

import Foundation

class ChatRepository {
    func getAllChats() -> [Chat] {
        // MySQL에서 데이터 받아오는 로직
        
        //날짜형식변환 DATETIME -> Date()
        let rawDateStrings = ["2024-09-25T15:30:45Z", "2024-09-26T10:20:30Z"]
        let dateFormatter = ISO8601DateFormatter()
        let dates = rawDateStrings.compactMap { dateFormatter.date(from: $0) }
        
        let chats = [
            Chat(id: 1, chatter: "cat1", profileImage: "cat1", lastSentTime: dates[0], lastMessageText: "Hello, I'm cat1"),
            Chat(id: 2, chatter: "cat2", profileImage: "cat2", lastSentTime: dates[1], lastMessageText: "Hello, I'm cat2"),
            ]
        
        return chats
    }
}
