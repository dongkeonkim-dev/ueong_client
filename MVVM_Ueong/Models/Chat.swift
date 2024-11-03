import Foundation

struct Chat: Identifiable, Decodable {
  let id: Int
  let partnerUsername: String
  let partnerNickname: String
  let partnerProfilePhotoURL: String?
  let lastMessageText: String
  let lastSentTime: Date?
  let relatedPostId: Int
  let unreadMessages: Int
  let lastSenderNickname: String
  
  enum CodingKeys: String, CodingKey {
    case id = "chat_id"
    case partnerUsername
    case partnerNickname
    case partnerProfilePhotoURL
    case lastMessageText
    case rawLastSentTime  // 서버에서 받는 날짜 문자열
    case relatedPostId
    case unreadMessages
    case lastSenderNickname
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
      // 기본 필드 디코딩
    id = try container.decode(Int.self, forKey: .id)
    partnerUsername = try container.decode(String.self, forKey: .partnerUsername)
    partnerNickname = try container.decode(String.self, forKey: .partnerNickname)
    partnerProfilePhotoURL = try container.decodeIfPresent(String.self, forKey: .partnerProfilePhotoURL)
    lastMessageText = try container.decode(String.self, forKey: .lastMessageText)
    relatedPostId = try container.decode(Int.self, forKey: .relatedPostId)
    unreadMessages = try container.decode(Int.self, forKey: .unreadMessages)
    lastSenderNickname = try container.decode(String.self, forKey: .lastSenderNickname)
    
      // 날짜 문자열을 Date로 변환
    let rawLastSentTime = try container.decode(String.self, forKey: .rawLastSentTime)
    lastSentTime = DATETIMEToDate(TIMESTAMP: rawLastSentTime)
  }
  
  init(
    id: Int,
    partnerUsername: String,
    partnerNickname: String,
    partnerProfilePhotoURL: String?,
    lastMessageText: String,
    lastSentTime: Date,
    relatedPostId: Int,
    unreadMessages: Int,
    lastSenderNickname: String
  ) {
    self.id = id
    self.partnerUsername = partnerUsername
    self.partnerNickname = partnerNickname
    self.partnerProfilePhotoURL = partnerProfilePhotoURL
    self.lastMessageText = lastMessageText
    self.relatedPostId = relatedPostId
    self.unreadMessages = unreadMessages
    self.lastSenderNickname = lastSenderNickname
    self.lastSentTime = lastSentTime
  }
  
}
