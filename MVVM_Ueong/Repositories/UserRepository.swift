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
    
    // 사용자 정보 수정 (파일 업로드 포함)
    func editUser(userData: EditedUserData) async throws {
        do {
            // 파일 데이터가 있는 경우 multipart 요청
            if let profilePhoto = userData.profilePhoto {
                try await APICall.shared.postMultipart(
                    endpoint: "user/edit-user",
                    parameters: [
                        "username": userData.username,
                        "email": userData.email,
                        "nickname": userData.nickname,
                        "password": userData.password
                    ],
                    fileData: profilePhoto,
                    fileName: "profilePhoto.jpg",
                    mimeType: "image/jpeg"
                )
            } else {
                // 파일 데이터가 없으면 일반 POST 요청 사용
                try await APICall.shared.post(
                    "user/edit-user",
                    body: userData
                )
            }
            print("User information updated successfully.")
        } catch {
            print("Error updating user information: \(error)")
            throw error
        }
    }
}
