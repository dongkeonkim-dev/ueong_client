//
//  Chat.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//

import Foundation

struct Chat: Identifiable {
    let id: UUID
    let name: String
    let lastMessage: String
    // 마지막 메시지 시간 데이터 추가필요
}
