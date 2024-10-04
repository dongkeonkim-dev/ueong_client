//import SwiftUI
//
//extension ChatListView {
//    class ViewModel: ObservableObject {
//        @Published var chats: [Chat] = [] // 채팅 목록을 저장하는 변수
//        var username: String
//
//        init() {
//            self.username = "username1" // 사용자 이름 설정
//            chatListUp(username: username) // 채팅 목록 요청
//            
//            // chatListResponse 알림 수신 등록
//            NotificationCenter.default.addObserver(forName: .chatListResponse, object: nil, queue: .main) { notification in
//                if let userInfo = notification.userInfo,
//                   let success = userInfo["success"] as? Bool,
//                   let chatsData = userInfo["chats"] as? [[String: Any]] {
//                    self.updateChats(with: chatsData) // 채팅 목록 업데이트
//                }
//            }
//        }
//
//        // 채팅 목록을 업데이트하는 메서드
//        private func updateChats(with chatsData: [[String: Any]]) {
//            self.chats = chatsData.compactMap { chatDict in
//                guard let id = chatDict["id"] as? Int,
//                      let partnerNickname = chatDict["partnerNickname"] as? String,
//                      let partnerProfilePhotoURL = chatDict["partnerProfilePhotoURL"] as? String,
//                      let lastMessageText = chatDict["lastMessageText"] as? String,
//                      let rawLastSentTime = chatDict["rawLastSentTime"] as? String,
//                      let relatedPostId = chatDict["relatedPostId"] as? Int,
//                      let unreadMessages = chatDict["unreadMessages"] as? Int,
//                      let partnerUsername = chatDict["partnerId"] as? String else {
//                    // 필수 값이 없으면 nil 반환
//                    return nil
//                }
//                return Chat(id: id,
//                            partnerUsername: partnerUsername,
//                            partnerNickname: partnerNickname,
//                            partnerProfilePhotoURL: partnerProfilePhotoURL,
//                            lastMessageText: lastMessageText,
//                            rawLastSentTime: rawLastSentTime,
//                            relatedPostId: relatedPostId, // 관련된 포스트 ID 추가
//                            unreadMessages: unreadMessages) // Chat 객체 생성
//            }
//        }
//
//        // 채팅 목록 요청 메서드
//        func chatListUp(username: String) {
//            SocketManagerService.shared.chatList(username: username) // 소켓을 통해 채팅 목록 요청
//        }
//    }
//}
//
