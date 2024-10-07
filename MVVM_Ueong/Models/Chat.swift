import Foundation

struct Chat: Identifiable, Decodable {
    let id: Int                          // 채팅 ID
    let partnerUsername: String           // 상대방의 사용자 이름
    let partnerNickname: String           // 상대방의 닉네임
    let partnerProfilePhotoURL: String?   // 상대방의 프로필 사진 URL (optional)
    let lastMessageText: String           // 마지막 메시지 텍스트
    let rawLastSentTime: String           // 마지막 메시지 전송 시간 (ISO 8601 형식)
    let relatedPostId: Int                // 관련된 포스트 ID
    let unreadMessages: Int                // 읽지 않은 메시지 수
    let lastSenderNickname: String         // 마지막 메시지를 보낸 사용자의 닉네임

    // CodingKeys를 통해 JSON 키와 Swift 속성 간의 매핑
    enum CodingKeys: String, CodingKey {
        case id = "chat_id"
        case partnerUsername = "partnerUsername" // 상대방의 사용자 이름 (JSON에서 이 값이 있을 경우 수정 필요)
        case partnerNickname = "partnerNickname"
        case partnerProfilePhotoURL = "partnerProfilePhotoURL" // 판매자 프로필 사진 URL
        case lastMessageText = "lastMessageText"
        case rawLastSentTime = "rawLastSentTime"
        case relatedPostId = "relatedPostId"
        case unreadMessages = "unreadMessages"
        case lastSenderNickname = "lastSenderNickname" // 마지막 메시지를 보낸 사용자의 닉네임
    }
}

