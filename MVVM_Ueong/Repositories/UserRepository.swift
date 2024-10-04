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
        let user: User = try await APICall.shared.get("user", parameters: [("username", username)])
        return user
    }
    
     // 사용자 정보 수정 (파일 업로드 포함)
    func editUser(userData: EditedUser, profileImage: Data?) async throws {
        do {
            let parameters = userData.toParams()
            
            var imagesToUpload: [(data: Data, fileName: String, mimeType: String)] = []
            if let profileImage = profileImage {
                imagesToUpload.append((data: profileImage, fileName: userData.username+".jpg", mimeType: "image/jpeg"))
            }
            try await APICall.shared.patch("user", parameters: parameters, files: imagesToUpload)
            print("User information updated successfully.")
        } catch {
            print("Error updating user information: \(error)")
            throw error
        }
    }
}
///Users/gimdong-geon/Documents/ueong_client/MVVM_Ueong/Repositories/UserRepository.swift:21:30 Instance member 'toParams' cannot be used on type 'EditedUser'; did you mean to use a value of this type instead?

