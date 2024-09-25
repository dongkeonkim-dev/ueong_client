//
//  ProfileViewModel.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//

import SwiftUI

extension MyAccountView {
    class ViewModel: ObservableObject {
        @Published var user: User = User(id: 0, username:"", nickname: "", email: "")
        let userId: Int
        private let userRepository = UserRepository()
        func getUserById() {
                
        }
        
        init(userId: Int) {
            self.userId = userId
            getUserDetail()
        }
        
        func getUserDetail() {
            self.user = userRepository.getUserById(userId: userId)
        }
    }
}


