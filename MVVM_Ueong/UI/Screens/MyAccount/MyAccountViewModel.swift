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
        let username: String
        private let userRepository = UserRepository()

        
        init() {
            self.username = "username2"
            getUserDetail()
        }
        
        func getUserDetail() {
            userRepository.getUserByUsername(username: username) { result in
                switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        self.user = user // UI 업데이트는 메인 스레드에서
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
}
