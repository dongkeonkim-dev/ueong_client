import SocketIO
import SwiftUI

// Notification.Name 확장
extension Notification.Name {
    static let checkChatResponse = Notification.Name("checkChatResponse")
    static let chatListResponse = Notification.Name("chatListResponse") // 추가
    static let socketConnected = Notification.Name("socketConnected")
    static let loadExistingMessagesResponse = Notification.Name("loadExistingMessagesResponse")
}

class SocketManagerService {
    static let shared = SocketManagerService()

    private var manager: SocketManager!
    private var socket: SocketIOClient!

    private init() {
        // Socket.IO 설정
        manager = SocketManager(socketURL: URL(string: baseURL)!, config: [.log(true), .compress])
        socket = manager.defaultSocket

        // 소켓 이벤트 리스너 설정
        setupEventListeners()
    }

    private func setupEventListeners() {
        // 소켓 연결 성공 시 데이터 수신
        socket.on(clientEvent: .connect) { data, ack in
            print("소켓 연결됨")
            // 소켓 연결 성공 시 메시지 전송
            self.socket.emit("acknowledge", "클라이언트가 연결되었습니다.")
            NotificationCenter.default.post(name: .socketConnected, object: nil)

        }

        // 소켓 연결 성공 시 메시지 수신
        socket.on("response") { data, ack in
            print("response 이벤트 수신")  // 로그 추가
            if let responseMessage = data[0] as? String {
                print("서버로부터의 응답: \(responseMessage)")
            } else {
                print("응답 데이터 형식 오류: \(data)")
            }
        }

        // 소켓 연결 오류 처리
        socket.on(clientEvent: .error) { data, ack in
            print("소켓 연결 오류: \(data)")
        }

        // Check Chat Response 처리
        socket.on("checkChatResponse") { data, ack in
            if let response = data[0] as? Bool {
                print("Chat exists: \(response)")
                NotificationCenter.default.post(name: .checkChatResponse, object: nil, userInfo: ["exists": response])
            }
        }

        // Chat List Response 처리 추가
        socket.on("chatListResponse") { data, ack in
            if let response = data[0] as? [String: Any],
               let success = response["success"] as? Bool,
               let chats = response["chats"] as? [[String: Any]] {

                print("Chat List Response 수신: 성공 여부 - \(success)")
                
                // Post notification with the chat list data
                NotificationCenter.default.post(name: .chatListResponse, object: nil, userInfo: ["success": success, "chats": chats])
            } else {
                print("채팅 리스트 응답 형식 오류: \(data)")
            }
        }
        
        // loadExistingMessagesResponse Response 처리 추가
        socket.on("loadExistingMessagesResponse") { data, ack in
            if let response = data[0] as? [String: Any],
               let success = response["success"] as? Bool,
               let messages = response["messages"] as? [[String: Any]] {

                print("Messages List Response 수신: 성공 여부 - \(success)")
                
                // Post notification with the chat list data
                NotificationCenter.default.post(name: .loadExistingMessagesResponse, object: nil, userInfo: ["success": success, "messages": messages])
            } else {
                print("메시지 리스트 응답 형식 오류: \(data)")
            }
        }
        
        
    }

    func connect() {
        socket.connect()
    }

    func disconnect() {
        socket.disconnect()
    }

    func sendMessage(message: String) {
        socket.emit("sendMessage", message)
    }
    
    func checkChat(username: String, postId: Int) {
        socket.emit("checkChat", username, postId)
    }
    
    func loadExistingMessages(chatId: Int) {
        socket.emit("loadExistingMessages", chatId)
    }
    
    func createChatRoom(sellerId: String, buyerId: String, postId: Post.ID) {
        socket.emit("createNewChatRoom", sellerId, buyerId, postId)
    }
    
    func chatList(username: String) {
        socket.emit("chatList", username)
    }
}

extension Notification.Name {
    static let newMessageReceived = Notification.Name("newMessageReceived")
}

