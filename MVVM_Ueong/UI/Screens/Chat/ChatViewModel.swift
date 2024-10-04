import Foundation

extension ChatView {
    class ViewModel: ObservableObject {
        @Published var messages: [Message] = []
        let username: String
        let partnerUsername: String // 맞춤법 수정
        let partnerNickname: String // 맞춤법 수정
        var relatedPost: Post
        
        // 채팅방 존재 여부를 저장하는 변수
        @Published var chatRoomExists: Bool = false
        
        // 초기화 생성자
        init(username: String, partnerUsername: String, partnerNickname: String, relatedPost: Post) {
            self.username = username // 매개변수로 전달된 username 사용
            self.partnerUsername = partnerUsername // 파라미터로 초기화
            self.partnerNickname = partnerNickname // 파라미터로 초기화
            self.relatedPost = relatedPost
        }
        
        func sendMessage(message: String) {
            if chatRoomExists {
                SocketManagerService.shared.sendMessage(message: message)
            } else {
                // 새로운 채팅방 생성 로직
                createNewChatRoom(message: message)
            }
        }
        
        // 채팅룸 존재 검사해서 존재하면 메시지 데이터 불러오기
        func checkChatRoom(username: String, postId: Int) {
            SocketManagerService.shared.checkChat(username: username, postId: postId)
            
            // NotificationCenter 옵저버 등록
            NotificationCenter.default.addObserver(forName: .checkChatResponse, object: nil, queue: .main) { notification in
                if let exists = notification.userInfo?["exists"] as? Bool {
                    self.chatRoomExists = exists
                    
                    if exists {
                        // 기존 채팅방이 존재하는 경우 기존 메시지 로드
                        self.loadExistingMessages()
                    }
                }
            }
        }
        
        // 메시지 데이터 불러오기
        func loadExistingMessages() {
            // 기존 메시지 불러오는 로직 구현
        }
        
        func createNewChatRoom(message: String) {
            // 새로운 채팅방 생성 요청을 보내는 로직
            SocketManagerService.shared.createChatRoom(sellerId: self.username, buyerId: self.partnerUsername, postId: self.relatedPost.id)
            
            // 채팅방이 성공적으로 생성된 경우
            self.chatRoomExists = true // 채팅방 존재 여부 업데이트
                
            // 새 메시지 전송
            SocketManagerService.shared.sendMessage(message: message)
        }
    }
}

