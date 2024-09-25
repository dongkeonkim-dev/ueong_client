//
//  AccountEditViewModel.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//

import SwiftUI

extension AccountEditView {
    class ViewModel: ObservableObject {
        @Published var user: User = User(id: 0, username:"", nickname: "", email: "")
        @Published var editedUserData: EditedUserData
        @Published var isImagePickerPresented = false
        
        let userId: Int
        private let userRepository = UserRepository()
        
        init(userId: Int) {
            self.userId = userId
            self.editedUserData = EditedUserData(username: "", password: "", confirmPassword: "", email: "", nickname: "")
            getUserDetail()
        }
        
        func getUserDetail() {
            self.user = userRepository.getUserById(userId: userId)
            
            // 불러온 유저 데이터를 기반으로 편집 가능한 데이터를 초기화
            self.editedUserData = EditedUserData(
                username: user.username,
                password: "",
                confirmPassword: "",
                email: user.email,
                nickname: user.nickname
            )
        }
        
        func saveChanges() {
            // 변경된 데이터를 저장하는 로직 구현 (유효성 검사 및 서버로 전송 등)
            print("저장된 닉네임: \(editedUserData.nickname)")
            print("저장된 이메일: \(editedUserData.email)")
        }
    }
}
