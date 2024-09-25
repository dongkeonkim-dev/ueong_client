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
        private let chatRepository = ChatRepository() // ChatRepository 인스턴스 생성
        
        init() {
            getAllChats()
        }
        
        func getAllChats() {
            // ChatRepository에서 데이터를 가져와 chats에 저장
            self.chats = chatRepository.getAllChats()
        }
    }
}
