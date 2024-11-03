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
        self.user = try await userRepository.getUser()
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
    
    func saveChanges() async throws -> UpdateResponse? {
        // 업로드 직전 데이터 로그 출력
      print("=== 업로드 전 데이터 확인 ===")
      print("Username: \(editedUser.username)")
      print("Email: \(editedUser.email)")
      print("Nickname: \(editedUser.nickname)")
      
      if let profileImage = profileImage {
        print("프로필 사진 크기: \(profileImage.count) bytes")
      } else {
        print("프로필 사진이 없습니다.")
      }
      do{// API 요청 보내기
        let response = try await userRepository.editUser(
          userData: editedUser,
          profileImage: profileImage
        )  // 저장 성공 시 UI 업데이트
        await MainActor.run {
          self.isImagePickerPresented = false
        }
        
        return response
      }catch{
        return nil
      }
    }
  }
}

