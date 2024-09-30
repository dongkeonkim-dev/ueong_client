//
//  UserRepository.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//

import Foundation

class UserRepository {
    // 비동기 함수로 사용자 이름에 따른 사용자 정보를 가져오기
    func getUserByUsername(username: String) async throws -> User {
        // APICall의 get 메서드를 호출하여 사용자 데이터를 받아옴
        let user: User = try await APICall.shared.get("user/by-username", parameters: [username])
        return user
    }
}


//let user = User(id: 12, username: "hong", nickname: "홍길동", email: "hong@gmail.com")
