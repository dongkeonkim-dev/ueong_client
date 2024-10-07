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
            
            var imagesToUpload: [File] = []
            if let profileImage = profileImage {
                // File 구조체를 사용하여 이미지 정보를 저장
                let file = File(data: profileImage, fieldName: "image", fileName: "\(userData.username).jpg", mimeType: "image/jpeg")
                imagesToUpload.append(file)
            }
            
            // API 호출
            try await APICall.shared.patch("user", parameters: parameters, files: imagesToUpload)
            print("User information updated successfully.")
        } catch {
            print("Error updating user information: \(error)")
            throw error
        }
    }

}

