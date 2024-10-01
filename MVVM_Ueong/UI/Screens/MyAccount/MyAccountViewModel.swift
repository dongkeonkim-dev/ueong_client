//
//  ProfileViewModel.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//

import SwiftUI

import SwiftUI

extension MyAccountView {
    class ViewModel: ObservableObject {
        @Published var user: User = User()
        let username: String
        private let userRepository = UserRepository()

        init() {
            username = "username1"
            fetchPage()
        }

        func fetchPage() {
            Task { @MainActor in
                self.user = try await userRepository.getUserByUsername(username: username)
            }
        }
    }
}

