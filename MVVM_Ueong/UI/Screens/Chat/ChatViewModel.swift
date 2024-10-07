import Foundation

extension ChatView {
    class ViewModel: ObservableObject {
        @Published var messages: [Message] = []
        let username: String
        let userNickname: String
        let partnerUsername: String // 맞춤법 수정
        let partnerNickname: String // 맞춤법 수정
        var relatedPost: Post
        var chatRoomId: Int?
        
        // 초기화 생성자
        init(chatRoomId: Int?, username: String, userNickname: String, partnerUsername: String, partnerNickname: String, relatedPost: Post) {
            self.username = username// 매개변수로 전달된 username 사용
            self.userNickname = userNickname
            self.partnerUsername = partnerUsername // 파라미터로 초기화
            self.partnerNickname = partnerNickname // 파라미터로 초기화
            self.relatedPost = relatedPost
            self.chatRoomId = chatRoomId
            
            
            if let chatRoomId {
                loadExistingMessages(chatId: chatRoomId)
                
                // loadExistingMessagesResponse 알림 수신 등록
                NotificationCenter.default.addObserver(forName: .loadExistingMessagesResponse, object: nil, queue: .main) { notification in
                    if let userInfo = notification.userInfo,
                       let success = userInfo["success"] as? Bool,
                       let messagesData = userInfo["messages"] as? [[String: Any]] {
                        print("Received chat data: \(messagesData)")
                        self.updateMessages(with: messagesData) // 채팅 목록 업데이트
                        
                    }
                }
                
            }
            
            
        }

        func sendMessageOrCreateChat(chatRoomId: Int?, username: String, partnerUsername: String, messageContent: String, postId: Int) {
            // 기존 채팅방 존재 검사
            if let chatRoomId {
                // 기존 채팅방이 발견된 경우 메시지 전송
                sendMessage(chatRoomId: chatRoomId, username: username, content: messageContent)
            } 
//            else {
//                // 기존 채팅방이 발견되지 않은 경우 새 채팅방 생성
//                let newChatRoomId = createChatRoom(username: username, partnerUsername: partnerUsername, postId: postId)
//                sendMessage(chatRoomId: newChatRoomId, username: username, content: messageContent)
//            }
        }

//        func createChatRoom(username: String, partnerUsername: String, postId: Int) -> Int {
//            // chats 테이블에 새 채팅방 생성하는 로직
//            // 여기에 데이터베이스 작업을 추가하여 새 채팅방을 생성하고 ID를 반환
//            let newChatRoomId = /* DB 작업으로 생성된 채팅방 ID 가져오기 */
//            print("새 채팅방 생성: ID = \(newChatRoomId) for partner = \(partnerUsername)")
//            return newChatRoomId
//        }

        func sendMessage(chatRoomId: Int, username: String, content: String) {
            // message 테이블에 메시지 추가하는 로직
            // 여기에 데이터베이스 작업을 추가하여 메시지를 전송
            print("(채팅방 ID = \(chatRoomId))에 (유저 ID = =\(username))님이 메시지 전송: 내용 = (\(content))")
            // DB 작업으로 메시지 저장하기
            SocketManagerService.shared.sendMessage(chatRoomId: chatRoomId, username: username, content: content)
            
        }
        
        
        
        // 메시지 데이터 불러오기
        func loadExistingMessages(chatId: Int) {
            SocketManagerService.shared.loadExistingMessages(chatId: chatId) // 소켓을 통해 채팅 목록 요청
        }
        
        // 메시지 목록을 업데이트하는 메서드
        private func updateMessages(with messagesData: [[String: Any]]) {
            self.messages = messagesData.compactMap { messageDict in
                // 전체 chatDict 출력
                print("messageDict: \(messageDict)")

                guard let id = messageDict["messageId"] as? Int else {
                    print("id가 없음: \(messageDict)")
                    return nil
                }

                guard let userNickname = messageDict["userNickname"] as? String else {
                    print("userNickname이 없음: \(messageDict)")
                    return nil
                }

                guard let messageText = messageDict["messageText"] as? String else {
                    print("messageText가 없음: \(messageDict)")
                    return nil
                }

                guard let sentTime = messageDict["sentTime"] as? String else {
                    print("sentTime가 없음: \(messageDict)")
                    return nil
                }

                guard let isRead = messageDict["isRead"] as? Int else {
                    print("isRead가 없음: \(messageDict)")
                    return nil
                }

                guard let username = messageDict["username"] as? String else {
                    print("username이 없음: \(messageDict)")
                    return nil
                }
                
                guard let chatId = messageDict["chatId"] as? Int else {
                    print("chatId이 없음: \(messageDict)")
                    return nil
                }


                let senderProfilePhotoURL: String? = (messageDict["senderProfilePhotoURL"] as? String == "<null") ? nil : (messageDict["senderProfilePhotoURL"] as? String)

                return Message(id: id,
                            senderUsername: username,
                            senderNickname: userNickname,
                            senderProfilePhotoURL: senderProfilePhotoURL,
                            messageText: messageText,
                            sentTime: sentTime,
                            isRead: isRead,
                            chatId: chatId
                            )
            }

            // 업데이트된 데이터 확인
            print("success update chats: \(self.messages)")
        }

        
        
    }
}







//// 채팅룸 존재 검사해서 존재하면 메시지 데이터 불러오기
//func checkChatRoom(username: String, partnerUsername: String, postId: Int) {
//    SocketManagerService.shared.checkChat(username: username, postId: postId)
//    
//    // NotificationCenter 옵저버 등록
//    NotificationCenter.default.addObserver(forName: .checkChatResponse, object: nil, queue: .main) { notification in
//        if let exists = notification.userInfo?["exists"] as? Bool {
//            self.chatRoomExists = exists
//            
//            if exists {
//                // 기존 채팅방이 존재하는 경우 기존 메시지 로드
//                self.loadExistingMessages(chatId: self.chatId)
//            }
//        }
//    }

