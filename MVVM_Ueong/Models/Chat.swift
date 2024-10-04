//
//  Chat.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//

import Foundation


struct Chat: Decodable {
    var id: Int //chat_id
    var partnerUsername: String // 상대방 아이디
    var partnerNickname: String // 상대방 닉네임
    var partnerProfilePhotoURL: String // 판매자 프로필 사진 URL
    var lastMessageText: String // 마지막 메시지 텍스트
    var rawLastSentTime: String // 마지막 메시지 시간 (서버에서 받은 문자열)
    var relatedPostId: Int // 관련된 포스트 ID
    var unreadMessages: Int // 읽지 않은 메시지 수
    

    // CodingKeys를 통해 JSON 키와 Swift 속성 간의 매핑
    enum CodingKeys: String, CodingKey {
        case id = "chat_id"
        case partnerUsername = "partnerId"
        case partnerNickname = "partner_nickname" // 판매자 닉네임
        case partnerProfilePhotoURL = "partner_profile_photo_url" // 판매자 프로필 사진 URL
        case lastMessageText = "last_message_text"
        case rawLastSentTime = "last_message_time"
        case relatedPostId = "post_id"
        case unreadMessages = "unread_messages"
    }
}



