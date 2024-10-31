//
//  ContentView.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @EnvironmentObject var appState: AppState
  var body: some View{
    Group {
      if appState.isLoggedIn {
        MainTabView()
          .environmentObject(appState)
      } else {
        AuthenticationView()
          .environmentObject(appState)
      }
    }
    .alert("알림", isPresented: $appState.showTokenExpiredAlert) {
      Button("확인") {
        appState.setLoggedIn(false)
      }
    } message: {
      Text(appState.tokenExpiredMessage)
    }
  }
}



#Preview {
  ContentView()
}
