//
//  User.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//

import Foundation

struct User: Decodable {
    let id: Int
    let username: String
    let nickname: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case id = "user_id"      // user_id를 id로 매핑
        case username
        case nickname
        case email
    }
}

struct EditedUserData {
    var username: String
    var password: String
    var confirmPassword: String
    var email: String
    var nickname: String
}
