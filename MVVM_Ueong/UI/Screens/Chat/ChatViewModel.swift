import Foundation

extension ChatView {
  class ViewModel: ObservableObject {
    @Published var messages: [Message] = []
    
    let userNickname: String
    let partnerUsername: String
    let partnerNickname: String
    var relatedPost: Post
    var chatRoomId: Int?
    let postRepository = PostRepository()
    
    private var sendMessageObserver: NSObjectProtocol?
    private var loadExistingMessagesObserver: NSObjectProtocol?
    
      // 초기화 생성자
    init(chatRoomId: Int?, username: String, userNickname: String, partnerUsername: String, partnerNickname: String, relatedPost: Post) {
      print("ChatViewModel 생성")
      self.userNickname = userNickname
      self.partnerUsername = partnerUsername
      self.partnerNickname = partnerNickname
      self.relatedPost = relatedPost
      self.chatRoomId = chatRoomId
      
      if let chatRoomId {
        loadExistingMessages(chatId: chatRoomId)
        
          // 기존 옵저버 제거
        if let observer = loadExistingMessagesObserver {
          NotificationCenter.default.removeObserver(observer)
        }
        
          // loadExistingMessagesResponse 알림 수신 등록
          // 새로운 옵저버 등록
        loadExistingMessagesObserver = NotificationCenter.default.addObserver(forName: .loadExistingMessagesResponse, object: nil, queue: .main) { notification in
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
      print("소켓통신")
    }
    
      // 메시지 데이터 불러오기
    func loadExistingMessages(chatId: Int) {
      SocketManagerService.shared.loadExistingMessages(chatId: chatId) // 소켓을 통해 채팅 목록 요청
      print("소켓통신")
    }
    
      // 메시지 목록을 업데이트하는 메서드
    private func updateMessages(with messagesData: [[String: Any]]) {
      self.messages = messagesData.compactMap { messageDict in
        return createMessage(from: messageDict)
      }
        //            print("success update chats: \(self.messages)")
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
            let rawSentTime = messageDict["sentTime"] as? String,
            let isRead = messageDict["isRead"] as? Int,
            let username = messageDict["username"] as? String,
            let chatId = messageDict["chatId"] as? Int else {
        print("messageDict 형식 오류: \(messageDict)")
        return nil
      }
      
      let sentTime = DATETIMEToDate(TIMESTAMP: rawSentTime)
      let senderProfilePhotoURL: String? = (messageDict["senderProfilePhotoURL"] as? String == "<null") ? nil : (messageDict["senderProfilePhotoURL"] as? String)
      
      return Message(
        id: id,
        senderUsername: username,
        senderNickname: userNickname,
        senderProfilePhotoURL: senderProfilePhotoURL,
        messageText: messageText,
        sentTime: sentTime,
        isRead: isRead,
        chatId: chatId)
    }
      
      
   func allReadMessage(chatRoomId: Int, username: String) {
        SocketManagerService.shared.allReadMessage(chatRoomId: chatRoomId, username: username)
    }
      
      
    
    
    func togglePostStatus(post: Post) {
      Task { @MainActor in
        do {
          let newStatus = post.status == "거래대기" ? "거래완료" : "거래대기"
          
            // API 호출
          let response = try await postRepository.changePostStatus(
            postId: post.id,
            status: newStatus
          )
          
            // View 새로고침 트리거
          objectWillChange.send()
          relatedPost.status = newStatus
          
        } catch {
          print("상태 변경 실패: \(error)")
        }
      }
    }
  }
}



