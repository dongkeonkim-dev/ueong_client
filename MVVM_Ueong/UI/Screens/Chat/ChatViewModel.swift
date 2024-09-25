//
//  ChatViewModel.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    let userId: Int
    let chatter: String
    let messageRepository = MessageRepository() // MessageRepository 인스턴스 생성
    
    init(userId: Int, chatter: String) {
        self.userId = userId
        self.chatter = chatter
        loadChatMessages() // 메시지 로드
    }
    
    // MessageRepository를 이용해 메시지 로드
    func loadChatMessages() {
        self.messages = messageRepository.getMessagesByChatter(userId: userId, chatter: chatter)
    }
    
    // 새로운 메시지 전송
    func sendMessage(_ text: String) {
        // 목킹 데이터로 메시지 추가
        let newMessage = Message(id: messages.count + 1, sender: "", text: text, sentTime: Date())
        
        // 목킹 데이터로 메시지 전송
        DispatchQueue.main.async {
            self.messages.append(newMessage)
        }
    }
}
