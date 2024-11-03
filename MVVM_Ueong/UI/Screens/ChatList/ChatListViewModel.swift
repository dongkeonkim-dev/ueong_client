import SwiftUI

extension ChatListView {
  class ViewModel: ObservableObject {
    @Published var chats: [Chat] = [] // 채팅 목록을 저장하는 변수
    var roomsIds: [Int] = [] // 채팅방 ID를 저장하는 변수
    
    private var chatListObserver: NSObjectProtocol?
      
    private var sendMessageObserver: NSObjectProtocol? // sendMessageResponse에 대한 새로운 옵저버

    
    init() {
      print("ChatListViewModel 생성")
      
    }
    
      // 채팅 목록을 업데이트하는 메서드
    private func updateChats(with chatsData: [[String: Any]]) {
      print("받은 데이터: \(chatsData)")  // 디버깅용
      
      self.chats = chatsData.compactMap { chatDict -> Chat? in
          // 필수 필드 검사
        guard
          let id = chatDict["id"] as? Int,
          let partnerUsername = chatDict["partnerUsername"] as? String,
          let partnerNickname = chatDict["partnerNickname"] as? String,
          let lastMessageText = chatDict["lastMessageText"] as? String,
          let rawLastSentTime = chatDict["rawLastSentTime"] as? String,
          let relatedPostId = chatDict["relatedPostId"] as? Int,
          let unreadMessages = chatDict["unreadMessages"] as? Int,
          let lastSenderNickname = chatDict["lastSenderNickname"] as? String,
          let lastSentTime = DATETIMEToDate(TIMESTAMP: rawLastSentTime)  // 기존 함수 사용
        else {
          print("누락된 필드가 있는 데이터: \(chatDict)")
          return nil
        }
        
        return Chat(
          id: id,
          partnerUsername: partnerUsername,
          partnerNickname: partnerNickname,
          partnerProfilePhotoURL: chatDict["partnerProfilePhotoURL"] as? String,
          lastMessageText: lastMessageText,
          lastSentTime: lastSentTime,
          relatedPostId: relatedPostId,
          unreadMessages: unreadMessages,
          lastSenderNickname: lastSenderNickname
        )
      }
      
      print("변환된 채팅 목록: \(self.chats)")
      self.roomsIds = self.chats.map { $0.id }
      
      
        //            NotificationCenter.default.post(name: .checkChatResponse, object: nil, userInfo: ["roomsIds": self.roomsIds])
      
      
        //            print("참여중인 채팅방: \(roomsIds)")
        // 업데이트된 데이터 확인
        //            print("success update chats: \(self.chats)")
        //            print("----------------------------------------------------------------------------------------------")
        //            print("----------------------------------------------------------------------------------------------")
        //            print("----------------------------------------------------------------------------------------------")
    }
    
    
    
      // 채팅 목록 요청 메서드
    func chatListUp(username: String) {
      SocketManagerService.shared.chatList(username: username) // 소켓을 통해 채팅 목록 요청
      print("소켓통신")
      
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
    
    
      // 채팅방 조인 메서드
    func joinChatRoom(roomIds: [Int]){
      SocketManagerService.shared.joinChatRoom(roomIds: roomIds)
      print("소켓통신")
      
    }
    
      // Method to fetch post by relatedPostId
    func fetchPost(by postId: Int) async -> Post? {
      let postRepository = PostRepository()
      let photoRepository = PhotoRepository() // 사진 리포지토리 추가
      
      do {
          // 포스트 가져오기
        var post = try await postRepository
          .getPostById(postId: postId)
        
          // 해당 포스트의 사진 가져오기
        post.photos = try await photoRepository
          .getPhotosByPostId(postId: postId)
        
        return post
      } catch {
          //                print("Failed to fetch post: \(error)")
        return nil
      }
    }
    
      func loadChat(completion: @escaping () -> Void) {
        chatListUp(username: UserDefaultsManager.shared.getUsername() ?? mockedUsername)
        print("chatListUp 호출됨")
        
        // 기존 옵저버 제거
        if let observer = chatListObserver {
          NotificationCenter.default.removeObserver(observer)
        }
        
        // chatListResponse 알림 수신 등록
        chatListObserver = NotificationCenter.default.addObserver(forName: .chatListResponse, object: nil, queue: .main) { notification in
          if let userInfo = notification.userInfo,
             let success = userInfo["success"] as? Bool,
             let chatsData = userInfo["chats"] as? [[String: Any]] {
            self.updateChats(with: chatsData) // 채팅 목록 업데이트
            print("updateChats 호출됨")
            
            self.joinChatRoom(roomIds: self.roomsIds)
            print("joinChatRoom 호출됨")
            
            // 모든 작업이 완료된 후 completion 핸들러 호출
            completion()
          } else {
            print("채팅 업데이트 실패: userInfo에 유효한 데이터가 없습니다.")
          }
        }
        
        // sendMessageResponse에 대한 옵저버 추가
        if let observer = sendMessageObserver {
          NotificationCenter.default.removeObserver(observer)
        }
        
        sendMessageObserver = NotificationCenter.default.addObserver(forName: .sendMessageResponse, object: nil, queue: .main) { notification in
          // 메시지를 전송한 후 채팅 목록을 새로 고침
          self.chatListUp(username: UserDefaultsManager.shared.getUsername() ?? mockedUsername)
          print("메시지 전송 후 채팅 목록 업데이트")
        }
      }
      
    }
    
  }
}
