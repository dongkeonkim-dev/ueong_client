import SwiftUI

struct LoginView: View {
  @EnvironmentObject var appState: AppState
  @StateObject private var viewModel = LoginViewModel()
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    NavigationView {
      VStack(spacing: 20) {
        Spacer()
        Image("logoWithName")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 220)
          
        TextField("ID", text: $viewModel.username)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .frame(width: 220)
          .padding(.horizontal, 60)
        
        SecureField("비밀번호", text: $viewModel.password)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .frame(width: 220)
          .padding(.horizontal, 60)
        
        if let errorMessage = viewModel.errorMessage {
          Text(errorMessage)
            .foregroundColor(.red)
            .padding(.horizontal)
        }
        
        Button(action: {
          Task {
            loginAction()
          }
        }) {
          if viewModel.isLoading {
            ProgressView()
              .progressViewStyle(CircularProgressViewStyle(tint: .white))
              .frame(maxWidth: .infinity)
              .padding()
              .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue.opacity(0.7)))
              .frame(width: 220)
              .padding(.horizontal, 40)
          } else {
            Text("로그인")
              .font(.system(size: 20).weight(.bold))
              .frame(maxWidth: .infinity)
              .padding()
              .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue.opacity(0.7)))
              .foregroundColor(Color.white)
              .frame(width: 220)
              .padding(.horizontal, 40)
          }
        }
        .disabled(viewModel.isLoading)
        
        Spacer()
      }
      .onChange(of: viewModel.loginSuccess) { success in
        if success {
          appState.isLoggedIn = true
          print(appState.isLoggedIn)
          presentationMode.wrappedValue.dismiss()
        }
      }
    }
  }
    // MARK: - 액션들
  private func loginAction() {
    Task{
      await viewModel.login()
    }
  }
}

#Preview {
  LoginView()
    .environmentObject(AppState())
}
