//
//  AccountEditViewModel.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//

import SwiftUI

extension AccountEditView {
    class ViewModel: ObservableObject {
        @Published var user: User = User(id: 0, username: "", nickname: "", email: "")
        @Published var editedUserData: EditedUserData
        @Published var isImagePickerPresented = false
        
        let username: String
        private let userRepository = UserRepository()
        
        init(userId: Int) {
            self.username = "username1"
            self.editedUserData = EditedUserData(username: "", password: "", confirmPassword: "", email: "", nickname: "")
            fetchPage()
        }
        
        func fetchPage(){
            Task{
                await getUserDetail()
            }
        }
        
        func getUserDetail() async {
            do {
                let user = try await userRepository.getUserByUsername(username: username)
                DispatchQueue.main.async {
                    self.user = user
                    // Initialize editable data based on loaded user data
                    self.editedUserData = EditedUserData(
                        username: user.username,
                        password: "",
                        confirmPassword: "",
                        email: user.email,
                        nickname: user.nickname
                    )
                }
            } catch {
                print("Error fetching user data: \(error)")
            }
        }
        
        func saveChanges() {
            // Logic to save changed data (validation and sending to server, etc.)
            print("Saved nickname: \(editedUserData.nickname)")
            print("Saved email: \(editedUserData.email)")
        }
    }
}

