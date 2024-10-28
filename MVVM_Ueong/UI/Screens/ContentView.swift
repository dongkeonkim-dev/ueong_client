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
  }
}



#Preview {
  ContentView()
}
