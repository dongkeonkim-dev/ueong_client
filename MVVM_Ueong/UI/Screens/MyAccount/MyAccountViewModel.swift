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
    var onLogout: (() -> Void)?
    
    init() {
      print("MyAccountViewModel 생성")
      fetchPage()
    }
    
    func logout() {
      TokenManager.shared.clearTokens(for:user.username)
      DispatchQueue.main.async{
        self.onLogout?()
      }
    }
    
    func fetchPage() {
      Task { @MainActor in
        self.user = try await userRepository.getUser()
      }
    }
    
    
    func deleteUser(){
      Task{
        try await userRepository.deactivateUser()
        logout()
      }
    }
  }
}




