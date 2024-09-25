//
//  User.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//

import Foundation

struct User: Identifiable {
    let id: Int
    let username: String
    let nickname: String
    let email: String
}

struct EditedUserData {
    var username: String
    var password: String
    var confirmPassword: String
    var email: String
    var nickname: String
}
