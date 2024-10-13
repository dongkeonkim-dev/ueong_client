import Foundation

extension ChatView {
    class ViewModel: ObservableObject {
        @Published var messages: [Message] = []
        let username: String
        let userNickname: String
        let partnerUsername: String
        let partnerNickname: String
        var relatedPost: Post
        var chatRoomId: Int?

        private var sendMessageObserver: NSObjectProtocol?
        
        // 초기화 생성자
        init(chatRoomId: Int?, username: String, userNickname: String, partnerUsername: String, partnerNickname: String, relatedPost: Post) {
            self.username = username
            self.userNickname = userNickname
            self.partnerUsername = partnerUsername
            self.partnerNickname = partnerNickname
            self.relatedPost = relatedPost
            self.chatRoomId = chatRoomId
            
            if let chatRoomId {
                loadExistingMessages(chatId: chatRoomId)
                
                // loadExistingMessagesResponse 알림 수신 등록
                NotificationCenter.default.addObserver(forName: .loadExistingMessagesResponse, object: nil, queue: .main) { notification in
                    if let userInfo = notification.userInfo,
                       let success = userInfo["success"] as? Bool,
                       let messagesData = userInfo["messages"] as? [[String: Any]] {
                        self.updateMessages(with: messagesData) // 채팅 목록 업데이트
                    }
                }
            }
        }

        func sendMessageOrCreateChat(chatRoomId: Int?, username: String, partnerUsername: String, messageContent: String, postId: Int) {

        
            sendMessage(chatRoomId: chatRoomId, username: username, partnerUsername: partnerUsername, content: messageContent, postId: postId)

        }

        func createChatRoom(username: String, partnerUsername: String, postId: Int) -> Int {
            // 소켓을 통해 새로운 채팅방 생성
            SocketManagerService.shared.createChatRoom(sellerId: partnerUsername, buyerId: username, postId: postId)
            return 1 // 실제 생성된 chatRoomId를 반환하는 로직으로 변경 필요
        }

        func sendMessage(chatRoomId: Int?, username: String, partnerUsername: String, content: String, postId: Int) {
            // 기존 옵저버 제거
            if let observer = sendMessageObserver {
                NotificationCenter.default.removeObserver(observer)
            }
            
            // 새로운 옵저버 등록
            sendMessageObserver = NotificationCenter.default.addObserver(forName: .sendMessageResponse, object: nil, queue: .main) { [weak self] notification in
                guard let self = self else { return }
                if let userInfo = notification.userInfo,
                   let success = userInfo["success"] as? Bool,
                   let newMessagesData = userInfo["messages"] as? [[String: Any]] {
                    if success {
                        self.appendMessages(with: newMessagesData) // 새로운 메시지 추가
                    } else {
                        print("메시지 전송 실패")
                    }
                }
            }

            print("(채팅방 ID = \(chatRoomId ?? -1))에 (유저 ID = \(username))님이 메시지 전송: 내용 = (\(content))")
            SocketManagerService.shared.sendMessage(chatRoomId: chatRoomId, username: username, partnerUsername: partnerUsername, content: content, postId: postId)
        }

        // 메시지 데이터 불러오기
        func loadExistingMessages(chatId: Int) {
            SocketManagerService.shared.loadExistingMessages(chatId: chatId) // 소켓을 통해 채팅 목록 요청
        }
        
        // 메시지 목록을 업데이트하는 메서드
        private func updateMessages(with messagesData: [[String: Any]]) {
            self.messages = messagesData.compactMap { messageDict in
                return createMessage(from: messageDict)
            }
            print("success update chats: \(self.messages)")
        }
        
        // 새로운 메시지를 messages 배열에 추가하는 메서드
        private func appendMessages(with messagesData: [[String: Any]]) {
            for messageDict in messagesData {
                if let newMessage = createMessage(from: messageDict) {
                    messages.append(newMessage) // 새로운 메시지 추가
                }
            }
            print("New messages added: \(self.messages)")
        }

        // 메시지 데이터를 Message 객체로 변환하는 메서드
        private func createMessage(from messageDict: [String: Any]) -> Message? {
            guard let id = messageDict["messageId"] as? Int,
                  let userNickname = messageDict["userNickname"] as? String,
                  let messageText = messageDict["messageText"] as? String,
                  let sentTime = messageDict["sentTime"] as? String,
                  let isRead = messageDict["isRead"] as? Int,
                  let username = messageDict["username"] as? String,
                  let chatId = messageDict["chatId"] as? Int else {
                print("messageDict 형식 오류: \(messageDict)")
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
                           chatId: chatId)
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

