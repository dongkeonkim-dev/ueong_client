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
        private let chatRepository = ChatRepository() // ChatRepository instance
        
        init() {
            self.username = "username1"
            fetchPage()
        }
        
        func fetchPage(){
            Task{
                await getAllChats()
            }
        }
        private func getAllChats() async {
            do {
                let chats = try await chatRepository.getChatsByUsername(username: username)
                DispatchQueue.main.async {
                    self.chats = chats // Update UI on main thread
                }
            } catch {
                print("Error fetching chats: \(error)")
            }
        }
    }
}
