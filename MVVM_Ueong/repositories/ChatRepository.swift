//
//  ChatRepository.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//

import Foundation

class ChatRepository {
    func getAllChats() -> [Chat] {
        // MySQL에서 받아온 날짜 문자열 배열
        let rawDateStrings = ["2024-09-25T15:30:45Z", "2024-09-26T10:20:30Z"]
        
        let dateFormatter = ISO8601DateFormatter()
        
        // 날짜 문자열 배열을 Date 객체로 변환
        let dates = rawDateStrings.compactMap { dateFormatter.date(from: $0) }
        
        let chat = [
            Chat(id: 1, name: "cat1", profileImage: "cat1", lastSentTime: dates[0], lastMessageText: "Hello, I'm cat1"),
            Chat(id: 2, name: "cat2", profileImage: "cat2", lastSentTime: dates[1], lastMessageText: "Hello, I'm cat2"),
            ]
        
        return chat
    }
}
