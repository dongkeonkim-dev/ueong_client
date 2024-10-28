//
//  AccountEditViewModel.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//

import SwiftUI

extension AccountEditView {
    class ViewModel: ObservableObject {
        @Published var user: User = User()
        @Published var editedUser = EditedUser()
        @Published var profileImage : Data?
        @Published var isImagePickerPresented = false
        @Published var imageSource: UIImagePickerController.SourceType = .photoLibrary
        @Published var editing: Bool = false
        
        private let userRepository = UserRepository()
        
        init() {
        }
        
        func fetchPage(){
            Task { @MainActor in
                self.editing = true
                self.user = try await userRepository.getUserByUsername(username: username)
                self.editedUser = EditedUser(
                    username: user.username,
                    password: "",
                    confirmPassword: "",
                    email: user.email,
                    nickname: user.nickname
                )
                self.isImagePickerPresented = false
            }
        }
        
        func saveChanges() {
            // 업로드 직전 데이터 로그 출력
            Task{ @MainActor in
                print("=== 업로드 전 데이터 확인 ===")
                print("Username: \(editedUser.username)")
                print("Email: \(editedUser.email)")
                print("Nickname: \(editedUser.nickname)")
                
                if let profileImage = profileImage {
                    print("프로필 사진 크기: \(profileImage.count) bytes")
                } else {
                    print("프로필 사진이 없습니다.")
                }
                
                // API 요청을 보내는 코드 (실제 서버로 업로드)
                
                try await userRepository.editUser(userData: editedUser, profileImage: profileImage)
                // 저장 후 현재 뷰를 닫기
//                self.isImagePickerPresented = false
                
            }
        }
    }
}

