// Views/Login/LoginView.swift
import SwiftUI
import LinkNavigator

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()

    var body: some View {
        VStack {
            Text("로그인")
                .font(.title)
                .padding()

            TextField("아이디", text: $viewModel.username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("비밀번호", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                viewModel.loginButton()
            }) {
                Text("로그인")
                    .foregroundColor(.white)
                    .frame(width: 60)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()

            Button(action: {
                //presenter.signupButton()
            }) {
                Text("회원가입")
                    .foregroundColor(.white)
                    .frame(width: 60)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }

            HStack {
                Button(action: {
                    // 아이디 찾기
                }) {
                    Text("아이디 찾기")
                        .font(.system(size: 13))
                        .underline()
                        .foregroundColor(.black)
                        .background(Color.white)
                        .cornerRadius(8)
                }
                Button(action: {
                    // 비밀번호 찾기
                }) {
                    Text("비밀번호 찾기")
                        .font(.system(size: 13))
                        .underline()
                        .foregroundColor(.black)
                        .background(Color.white)
                        .cornerRadius(8)
                }

            }
            .padding(25)
        }
        .padding()
    }
}
