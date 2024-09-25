//
//  ProfileViewModel.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//

import SwiftUI

extension MyAccountView {
    class ViewModel: ObservableObject {
        @Published var user: User = User(id: 3, name: "홍길동", email: "hong@gmail.com")
    }
}


