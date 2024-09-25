//
//  MessageRepository.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//
import Foundation

class MessageRepository {
    func getMessagesByChatter(userId: Int, chatter: String) -> [Message] { // userId의 타입 명시
        // MySQL에서 데이터 받아오는 로직 (목킹 데이터 사용)
        
        // 날짜 형식 변환: MySQL DATETIME -> Swift Date()
        let rawDateStrings = ["2024-09-25T15:30:45Z", "2024-09-25T15:32:30Z", "2024-09-25T15:35:30Z"]
        let dateFormatter = ISO8601DateFormatter()
        let dates = rawDateStrings.compactMap { dateFormatter.date(from: $0) }
        
        // 예시 메시지 데이터 생성
        let messages = [
            Message(id: 19, sender: "cat1", text: "Hello, how are you?", sentTime: dates[0]),
            Message(id: 20, sender: "", text: "I'm fine, thanks!", sentTime: dates[1]),
            Message(id: 43, sender: "cat1", text: "Good to hear!", sentTime: dates[2])
        ]
        
        return messages
    }
}
