import SwiftUI

extension ChatListView {
    class ViewModel: ObservableObject {
        @Published var chats: [Chat] = [] // 채팅 목록을 저장하는 변수
        var username: String

        init() {
            self.username = "username1" // 사용자 이름 설정
            chatListUp(username: username)
            
            
            // chatListResponse 알림 수신 등록
            NotificationCenter.default.addObserver(forName: .chatListResponse, object: nil, queue: .main) { notification in
                if let userInfo = notification.userInfo,
                   let success = userInfo["success"] as? Bool,
                   let chatsData = userInfo["chats"] as? [[String: Any]] {
                    print("Received chat data: \(chatsData)")
                    self.updateChats(with: chatsData) // 채팅 목록 업데이트
                }
            }
            
            
        }

        // 채팅 목록을 업데이트하는 메서드
        private func updateChats(with chatsData: [[String: Any]]) {
            self.chats = chatsData.compactMap { chatDict in
                // 전체 chatDict 출력
                print("chatDict: \(chatDict)")

                guard let id = chatDict["id"] as? Int else {
                    print("id가 없음: \(chatDict)")
                    return nil
                }
                
                guard let partnerNickname = chatDict["partnerNickname"] as? String else {
                    print("partnerNickname이 없음: \(chatDict)")
                    return nil
                }
                
                guard let lastMessageText = chatDict["lastMessageText"] as? String else {
                    print("lastMessageText가 없음: \(chatDict)")
                    return nil
                }
                
                guard let rawLastSentTime = chatDict["rawLastSentTime"] as? String else {
                    print("rawLastSentTime가 없음: \(chatDict)")
                    return nil
                }
                
                guard let relatedPostId = chatDict["relatedPostId"] as? Int else {
                    print("relatedPostId가 없음: \(chatDict)")
                    return nil
                }
                
                guard let unreadMessages = chatDict["unreadMessages"] as? Int else {
                    print("unreadMessages가 없음: \(chatDict)")
                    return nil
                }
                
                guard let partnerUsername = chatDict["partnerUsername"] as? String else {
                    print("partnerUsername이 없음: \(chatDict)")
                    return nil
                }
                
                guard let lastSenderNickname = chatDict["lastSenderNickname"] as? String else {
                    print("lastSenderNickname이 없음: \(chatDict)")
                    return nil
                }
                
                let partnerProfilePhotoURL: String? = (chatDict["partnerProfilePhotoURL"] as? String == "<null") ? nil : (chatDict["partnerProfilePhotoURL"] as? String)
                
                return Chat(id: id,
                            partnerUsername: partnerUsername,
                            partnerNickname: partnerNickname,
                            partnerProfilePhotoURL: partnerProfilePhotoURL,
                            lastMessageText: lastMessageText,
                            rawLastSentTime: rawLastSentTime,
                            relatedPostId: relatedPostId,
                            unreadMessages: unreadMessages,
                            lastSenderNickname: lastSenderNickname)
            }
            
            // 업데이트된 데이터 확인
            print("success update chats: \(self.chats)")
        }



        // 채팅 목록 요청 메서드
        func chatListUp(username: String) {
            SocketManagerService.shared.chatList(username: username) // 소켓을 통해 채팅 목록 요청
            
        }
        
        
        // 채팅방 확인 메서드
        func checkChatRoom(partnerUsername: String, postId: Int) -> Int? {
            for chat in chats {
                if chat.partnerUsername == partnerUsername && chat.relatedPostId == postId {
                    return chat.id // 일치하는 채팅이 있을 경우 ID 반환
                }
            }
            return nil // 일치하는 채팅이 없을 경우 nil 반환
        }
    }
    
}

