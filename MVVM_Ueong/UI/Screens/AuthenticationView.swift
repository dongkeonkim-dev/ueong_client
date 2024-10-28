import SwiftUI

struct AuthenticationView: View {
  @EnvironmentObject var appState: AppState
  @State private var showLogin: Bool = true
  
  var body: some View {
    VStack {
      if showLogin {
        LoginView()
          .environmentObject(appState)
      } else {
        SignupView()
          .environmentObject(appState)
      }
      
      Spacer()
      
      Button(action: {
        showLogin.toggle()
      }) {
        Text(showLogin ? "회원가입" : "로그인")
          .font(.system(size: 16).weight(.bold))
          .foregroundColor(Color.blue)
      }
      .padding()
    }
  }
}

#Preview {
  AuthenticationView()
    .environmentObject(AppState())
}
