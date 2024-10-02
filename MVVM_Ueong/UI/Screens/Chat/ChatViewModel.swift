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
    let patnerUsername: String
    let patnerNickname: String
    var relatedPost: Post
    
    // 내 유저 아이디와 포스트 아이디를 chats 테이블의 넘겨줘서 이미 채팅방이 존재하는지 확인한다. 이미 대화하고 있는 상품이라면 채팅방을 불러온다.
    init(username: String, patnerUsername: String, patnerNickname: String, relatedPost: Post) {
        self.username = "username1" // 추후에 username파라미터로 초기화
        self.patnerUsername = patnerUsername
        self.patnerNickname = patnerNickname
        self.relatedPost = relatedPost
    }
    
    // 비동기 작업을 순차적으로 처리하도록 개선한 메서드
    func fetchPage(){
        Task{
            await fetchMessages()
            await fetchPost()
        }
    }

    private func fetchMessages() async {
        
    }
    
    private func fetchPost() async {
        
    }

    
}
