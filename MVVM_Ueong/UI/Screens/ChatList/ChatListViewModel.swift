//
//  ChatListViewModel.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//

import SwiftUI

extension ChatList {
    class ViewModel: ObservableObject{
        @Published var chats: [Chat] = []
        
        init() {
            loadChats()
        }
        
        func loadChats() {
            // 실제 데이터는 API나 로컬에서 가져올 수 있습니다.
            self.chats = [
                Chat(id: UUID(), name: "Bob", lastMessage: "hello"),
                Chat(id: UUID(), name: "Bob", lastMessage: "hahahah")
            ]
        }
        
    }
}
