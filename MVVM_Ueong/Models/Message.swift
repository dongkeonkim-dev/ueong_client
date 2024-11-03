//
//  Message.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//
import Foundation
struct Message: Identifiable, Equatable, Decodable {
  let id: Int
  var senderUsername: String
  var senderNickname: String
  var senderProfilePhotoURL: String?
  let messageText: String
  let sentTime: Date?
  var isRead: Int
  let chatId: Int
  
  enum CodingKeys: String, CodingKey {
    case id = "id"  // 또는 "message_id"
    case senderUsername
    case senderNickname
    case senderProfilePhotoURL
    case messageText
    case rawSentTime = "sentTime"  // ISO 형식의 날짜 문자열
    case isRead
    case chatId
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
      // 기본 필드 디코딩
    id = try container.decode(Int.self, forKey: .id)
    senderUsername = try container.decode(String.self, forKey: .senderUsername)
    senderNickname = try container.decode(String.self, forKey: .senderNickname)
    senderProfilePhotoURL = try container.decodeIfPresent(String.self, forKey: .senderProfilePhotoURL)
    messageText = try container.decode(String.self, forKey: .messageText)
    isRead = try container.decode(Int.self, forKey: .isRead)
    chatId = try container.decode(Int.self, forKey: .chatId)
    
      // 날짜 변환
    let rawSentTime = try container.decode(String.self, forKey: .rawSentTime)
    sentTime = DATETIMEToDate(TIMESTAMP: rawSentTime)
  }
  
    // 일반 생성자 추가
  init(
    id: Int,
    senderUsername: String,
    senderNickname: String,
    senderProfilePhotoURL: String?,
    messageText: String,
    sentTime: Date?,
    isRead: Int,
    chatId: Int
  ) {
    self.id = id
    self.senderUsername = senderUsername
    self.senderNickname = senderNickname
    self.senderProfilePhotoURL = senderProfilePhotoURL
    self.messageText = messageText
    self.sentTime = sentTime
    self.isRead = isRead
    self.chatId = chatId
  }
}
