import SwiftUI

struct SignupView: View {
  @EnvironmentObject var appState: AppState
  @StateObject private var viewModel = SignupViewModel()
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    NavigationView {
      VStack(spacing: 20) {
        Spacer()
        Text("회원가입")
          .font(.largeTitle)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .frame(width: 220)
          .padding()
        
        TextField("ID", text: $viewModel.username)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .frame(width: 220)
          .padding(.horizontal)
        
        SecureField("비밀번호", text: $viewModel.password)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .frame(width: 220)
          .textContentType(.oneTimeCode)
          .padding(.horizontal)
        
        SecureField("비밀번호 확인", text: $viewModel.confirmPassword)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .frame(width: 220)
          .textContentType(.oneTimeCode)
          .padding(.horizontal)
        
        TextField("이메일", text: $viewModel.email)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .frame(width: 220)
          .padding(.horizontal)
          .keyboardType(.emailAddress)
        
        TextField("닉네임", text: $viewModel.nickname)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .frame(width: 220)
          .padding(.horizontal)
        
        if let errorMessage = viewModel.errorMessage {
          Text(errorMessage)
            .foregroundColor(.red)
            .padding(.horizontal)
        }
        
        Button(action: {
          Task {
            await viewModel.signup()
          }
        }) {
          if viewModel.isLoading {
            ProgressView()
              .progressViewStyle(CircularProgressViewStyle(tint: .white))
              .frame(maxWidth: .infinity)
              .padding()
              .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue.opacity(0.7)))
              .frame(width: 220)
              .padding(.horizontal)
          } else {
            Text("회원가입")
              .font(.system(size: 20).weight(.bold))
              .frame(maxWidth: .infinity)
              .padding()
              .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue))
              .frame(width: 220)
              .padding(.horizontal)
              .foregroundColor(Color.white)
          }
        }
        .disabled(viewModel.isLoading)
        
        Spacer()
      }
      .onChange(of: viewModel.signupSuccess) { success in
        if success {
          appState.isLoggedIn = true
          presentationMode.wrappedValue.dismiss()
        }
      }
    }
  }
}

#Preview {
  SignupView()
    .environmentObject(AppState())
}
