//
//  ChatListViewModel.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//

import SwiftUI

extension ChatListView {
    class ViewModel: ObservableObject {
        @Published var chats: [Chat] = []
        let username: String
        private let chatRepository = ChatRepository() // ChatRepository 인스턴스 생성
        
        init() {
            self.username = "username1"
            getAllChats()
        }
        
        func getAllChats() {
            // ChatRepository에서 데이터를 비동기적으로 가져와 chats에 저장
            chatRepository.getChatsByUsername(username: username) { result in
                switch result {
                case .success(let chats):
                    DispatchQueue.main.async {
                        self.chats = chats // UI 업데이트는 메인 스레드에서
                    }
                case .failure(let error):
                    print("Error fetching chats: \(error)")
                }
            }
        }
    }
}
