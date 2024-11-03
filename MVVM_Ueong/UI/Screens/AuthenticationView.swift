import SwiftUI

struct AuthenticationView: View {
  @EnvironmentObject var appState: AppState
  @State private var showLogin: Bool = true
  @State private var isTransitioningFromSignup: Bool = false  // 전환 상태 추적
  
  var body: some View {
    VStack {
      if showLogin {
        LoginView(isFromSignup: isTransitioningFromSignup)
          .environmentObject(appState)
      } else {
        SignupView()
          .environmentObject(appState)
      }
      
      Spacer()
      
      Button(action: {
        isTransitioningFromSignup = !showLogin  // 전환 전 상태 저장
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
