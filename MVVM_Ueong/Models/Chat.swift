//
//  Chat.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//

import Foundation

//struct Chat: Identifiable {
//    let id: Int
//    let chatter: String
//    let profileImage: String
//    let rawLastSentTime: String // 서버에서 받은 날짜 문자열
//    let lastSentTime: Date
//    let lastMessageText: String
//}

struct Chat: Decodable {
    var id: Int
    var sellerUsername: String
    var buyerUsername: String
    var sellerNickname: String
    var buyerNickname: String
    var lastMessageText: String
    var rawlastSentTime: String
    var relatedPostId: Int
    
    var lastSentTime: Date?
    var chatterUsername: String?
    var chatterNickname: String?
    
    // CodingKeys를 통해 JSON 키와 Swift 속성 간의 매핑
    enum CodingKeys: String, CodingKey {
        case id = "chat_id"
        case sellerUsername = "seller_username"
        case buyerUsername = "buyer_username"
        case sellerNickname = "seller_nickname"
        case buyerNickname = "buyer_nickname"
        case lastMessageText = "message_text"
        case rawlastSentTime = "sent_time"
        case relatedPostId = "post_id"
    }
}
