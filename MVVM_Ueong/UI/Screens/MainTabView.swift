  //
  //  MainTabView.swift
  //  MVVM_Ueong
  //
  //  Created by 김석원 on 9/24/24.
  //
import SwiftUI

struct MainTabView: View {
  init() {
      // Customize the tab bar appearance
    UITabBar.appearance().backgroundColor = UIColor.systemGray6 // Tab bar background color
    UITabBar.appearance().barTintColor = UIColor.white           // Tab bar tint color
    UITabBar.appearance().unselectedItemTintColor = UIColor.gray // Unselected tab item color
    UITabBar.appearance().tintColor = UIColor.systemBlue         // Selected tab item color
  }
  var body: some View {
    NavigationStack {
        //            ZStack {
        //                // 탭 뷰의 배경색 설정
        //                Color.white // 원하는 색상으로 변경 가능
        //                    .edgesIgnoringSafeArea(.all) // 화면의 모든 가장자리까지 색상을 확장
      
      TabView {
        PostsList()
          .tabItem {
            Image(systemName: "house")
            Text("홈")
          }
        
        ChatListView(viewModel: ChatListView.ViewModel())
          .tabItem {
            Image(systemName: "message")
            Text("채팅")
          }
        
        FavoritesListView()
          .tabItem {
            Image(systemName: "heart")
            Text("좋아요")
          }
        
        MyAccountView()
          .tabItem {
            Image(systemName: "person")
            Text("내 정보")
          }
          //                }
      }
      .environment(\.horizontalSizeClass, .compact)
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}
