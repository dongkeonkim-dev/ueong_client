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
        private let userRepository = UserRepository()

        init() {
            print("MyAccountViewModel 생성")
            fetchPage()
        }

        func fetchPage() {
            Task { @MainActor in
                self.user = try await userRepository.getUserByUsername(username: username)
            }
        }
    }
}

