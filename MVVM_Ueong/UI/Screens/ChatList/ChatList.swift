//
//  ChatList.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//

import SwiftUI

struct ChatList: View {
    @ObservedObject var viewModel: ChatList.ViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.chats, id: \.self) { chat in
                Text(chat)
            }
            .navigationTitle("채팅")
        }
    }
}

