//
//  Chat.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//

import Foundation

struct Chat: Identifiable {
    let id: Int
    let name: String
    let profileImage: String
    let lastSentTime: Date
    let lastMessageText: String
}
