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
    let id: Int
    let senderUsername: String
    let receiverUsername: String  //판매자 id
    let senderNickname: String    //구매자
    let receiverNickname: String  //판매자
    let lastMessageText: String   
    let rawlastSentTime: String
    
    var lastSentTime: Date?
    var chatterUsername: String?
    var chatterNickname: String?
    
    // CodingKeys를 통해 JSON 키와 Swift 속성 간의 매핑
    enum CodingKeys: String, CodingKey {
        case id = "chat_id"
        case senderNickname = "sender_nickname"
        case receiverNickname = "receiver_nickname"
        case lastMessageText = "message_text"
        case rawlastSentTime = "sent_time"
        case senderUsername = "sender_username"
        case receiverUsername = "receiver_username"
    }
}
