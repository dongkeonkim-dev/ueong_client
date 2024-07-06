// Views/Signup/SignupView.swift
import LinkNavigator
import SwiftUI

struct SignupView: View {
    let navigator: LinkNavigatorType
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        VStack {
            Text("회원가입")
                .font(.title)
                .padding()
            
            TextField("이메일", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .overlay(
                    RoundedRectangle(cornerRadius: 2) // 테두리의 모양을 지정
                        .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                )
            
                .padding()
            
            TextField("닉네임", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .overlay(
                    RoundedRectangle(cornerRadius: 2) // 테두리의 모양을 지정
                        .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                )
                .padding()
            
            TextField("아이디", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .overlay(
                    RoundedRectangle(cornerRadius: 2) // 테두리의 모양을 지정
                        .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                )
                .padding()
            
            SecureField("비밀번호", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .overlay(
                    RoundedRectangle(cornerRadius: 2) // 테두리의 모양을 지정
                        .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                )
                .padding()
            
            SecureField("비밀번호 확인", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .overlay(
                    RoundedRectangle(cornerRadius: 2) // 테두리의 모양을 지정
                        .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                )
                .padding()
            
            Button(action: {
                //self.register()
            }) {
                Text("회원가입")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("회원가입 결과"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
            }
        }
        .padding()
    }
    
    private func register() {
//        guard !username.isEmpty, !email.isEmpty, !password.isEmpty, password == confirmPassword else {
//            alertMessage = "모든 필드를 올바르게 입력해주세요."
//            showingAlert = true
//            return
//        }
//        
//        APIService.shared.register(username: username, password: password) { result in
//            switch result {
//            case .success(let message):
//                alertMessage = "회원가입 성공: \(message)"
//            case .failure(let error):
//                alertMessage = "회원가입 실패: \(error.localizedDescription)"
//            }
//            showingAlert = true
//        }
    }
}

//#Preview {
//    SignupView(navigator: LinkNavigator(dependency: AppDependency(), builders: AppRouterGroup(authService: appDelegate.authService).routers))
//}

