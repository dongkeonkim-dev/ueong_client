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
    let sentTime: String
    var isRead: Int
    let chatId: Int
    

    // CodingKeys를 통해 JSON 키와 Swift 속성 간의 매핑
//    enum CodingKeys: String, CodingKey {
//        case id = "message_id"
//        case sender = "sender_username"
//        case text = "message_text"
//        case rawSentTime = "sent_time"
//    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(Int.self, forKey: .id)
//        sender = try container.decode(String.self, forKey: .sender)
//        text = try container.decode(String.self, forKey: .text)
//        
//        let rawSentTime = try container.decode(String.self, forKey: .rawSentTime)
//        let dateFormatter = ISO8601DateFormatter()
//        sentTime = dateFormatter.date(from: rawSentTime) //?? Date(timeIntervalSince1970: 0)
//    }

}
