//
//  UserRepository.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//

import Foundation

class UserRepository {
    func getUserByUsername(username: String, completion: @escaping (Result<User, Error>) -> Void) {
        // API 클래스의 get 메서드를 호출하여 데이터를 받아옴
        APICall.shared.get("user/by-username", parameters: ["username": username], completion: completion)
    }
}


//let user = User(id: 12, username: "hong", nickname: "홍길동", email: "hong@gmail.com")
