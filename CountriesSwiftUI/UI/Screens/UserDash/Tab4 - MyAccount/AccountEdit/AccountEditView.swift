import LinkNavigator
import SwiftUI

import SwiftUI

struct EditProfilePage: View {
    let navigator: LinkNavigatorType
    @State private var nickname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = "" 
    @State private var profileImage: UIImage? // Add a state variable to hold the profile image
    @State private var isImagePickerPresented = false
    
    struct User {
        let id: String
        let email: String
        let nickname: String
    }

    let user = User(id: "사용자ID", email: "user@kku.ac.kr", nickname: "별명")
    
    init(navigator: LinkNavigatorType) {
            self.navigator = navigator
            self._email = State(initialValue: user.email) //
            self._nickname = State(initialValue: user.nickname)
        }
    
    var body: some View {
        VStack{
            ScrollView {
                VStack(spacing: 20) {
                    HStack(){
                        Text("정보수정")
                            .font(.system(size: 25).weight(.bold))
                        Spacer()
                    }
                    VStack {
                        if let image = profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                                .foregroundColor(.gray)
                        }
                        HStack{
                            Button(action: {
                                isImagePickerPresented = true
                            }) {
                                VStack{
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 25, height: 25)
                                }
                                .font(.system(size: 14))
                                .foregroundColor(.blue)
                                
                            }
                            .padding(.top, 5)
                            Button(action: {
                                isImagePickerPresented = true
                            }) {
                                VStack{
                                    Image(systemName: "camera")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 25, height: 25)
                                }
                                .font(.system(size: 14))
                                .foregroundColor(.blue)
                            }
                            .padding(.leading, 5)
                        }
                    }
                    .padding()
                    
                    //별명
                    HStack {
                        TextField("별명", text: $nickname)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(
                                RoundedRectangle(cornerRadius: 2) // 테두리의 모양을 지정
                                    .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                            )
                    }
                    .font(.title3)
                    .padding(.horizontal)
                    //이메일
                    HStack {
                        TextField("이메일", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(
                                RoundedRectangle(cornerRadius: 2) // 테두리의 모양을 지정
                                    .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                            )
                    }
                    .font(.title3)
                    .padding(.horizontal)
                    .padding(.top,10)
                    //비밀번호
                    HStack {
                        SecureField("비밀번호를 입력하세요", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(
                                RoundedRectangle(cornerRadius: 2) // 테두리의 모양을 지정
                                    .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                            )
                    }
                    .font(.title3)
                    .padding(.horizontal)
                    .padding(.top,10)
                    //비밀번호확인
                    HStack {
                        SecureField("비밀번호 확인", text: $confirmPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(
                                RoundedRectangle(cornerRadius: 2) // 테두리의 모양을 지정
                                    .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                            )
                    }
                    .font(.title3)
                    .padding(.horizontal)
                    .padding(.top,10)
                }
                .padding()
                .padding(.leading,5)
                HStack{
                    Button(action: { navigator.back(isAnimated: true) }) {
                      Text("완료")
                    }
                    .padding()
                    Button(action: { navigator.back(isAnimated: true) }) {
                      Text("취소")
                    }
                    .padding()
                }
            }
        }
        Spacer()
    }
}


