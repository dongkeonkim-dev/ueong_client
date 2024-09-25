//
//  UserRepository.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//

import Foundation

class UserRepository {
    func getUserById(userId:Int) -> User {
        // MySQL에서 데이터 받아오는 로직
        
        let user = User(id: 3, username: "hong", nickname: "홍길동", email: "hong@gmail.com")
        
        return user
    }
}
