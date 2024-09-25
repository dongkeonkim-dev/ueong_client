//
//  Profile.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//

import SwiftUI

struct Profile: View {
    @ObservedObject var viewModel: Profile.ViewModel
        
        var body: some View {
            NavigationView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("이름: \(viewModel.user.name)")
                    Text("이메일: \(viewModel.user.email)")
                }
                .padding()
              
            }
        }
}

#Preview {
    Profile(viewModel: Profile.ViewModel())
}
