//
//  ChatViewModel.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    let username: String
    let chatterUsername: String
    let chatterNickname: String
    let messageRepository = MessageRepository() // MessageRepository 인스턴스 생성
    
    init(chatterUsername: String, chatterNickname: String) {
        self.username = "username1"
        self.chatterUsername = chatterUsername
        self.chatterNickname = chatterNickname
        loadChatMessages() // 메시지 로드
    }
    
    // MessageRepository를 이용해 메시지 로드
    func loadChatMessages() {
        messageRepository.getMessagesByChatter(username: username, chatter: chatterUsername) { result in
            switch result {
            case .success(let messages):
                DispatchQueue.main.async {
                    self.messages = messages // UI 업데이트는 메인 스레드에서
                }
            case .failure(let error):
                print("Error fetching messages: \(error)")
            }
        }
        
    }
    
    // 새로운 메시지 전송
    func sendMessage(_ text: String) {
//        // 목킹 데이터로 메시지 추가
//        let newMessage = Message(id: messages.count + 1, sender: "", text: text, sentTime: Date())
//        
//        // 목킹 데이터로 메시지 전송
//        DispatchQueue.main.async {
//            self.messages.append(newMessage)
//        }
    }
}
