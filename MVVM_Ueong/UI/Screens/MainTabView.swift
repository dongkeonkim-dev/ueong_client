//
//  MainTabView.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            PostsList(viewModel: PostsList.ViewModel())
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                }
            
            ChatListView(viewModel: ChatListView.ViewModel())
                .tabItem {
                    Image(systemName: "message")
                    Text("채팅")
                }
            
            FavoritesList(viewModel: FavoritesList.ViewModel())
                .tabItem {
                    Image(systemName: "heart")
                    Text("좋아요")
                }
            
            MyAccountView(viewModel: MyAccountView.ViewModel())
                .tabItem {
                    Image(systemName: "person")
                    Text("내 정보")
                }
        }
    }
}
