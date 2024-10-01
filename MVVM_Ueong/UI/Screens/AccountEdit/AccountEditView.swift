//
//  AccountEditView.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//
import SwiftUI

struct AccountEditView: View {
    @ObservedObject var viewModel: AccountEditView.ViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 정보 수정 헤더
                    HStack {
                        Text("정보수정")
                            .font(.system(size: 25).weight(.bold))
                        Spacer()
                    }

                    // 프로필 이미지
                    VStack {
                        if let profilePhotoData = viewModel.editedUserData.profilePhoto,
                           let uiImage = UIImage(data: profilePhotoData) {
                            // 새로 선택된 이미지가 있을 때 표시
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 325, height: 325)
                                .clipped()
                                .clipShape(Circle())
                        } else if let photoUrl = viewModel.user.profilePhotoUrl,
                                  let url = URL(string: baseURL.joinPath(photoUrl)) {
                            // 서버에서 불러온 기존 이미지를 표시
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 325, height: 325)
                                    .clipped()
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 325, height: 325)
                            }
                        } else {
                            // 기본 이미지
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 325, height: 325)
                                .foregroundColor(.gray)
                        }

                        HStack {
                            Button(action: {
                                viewModel.isImagePickerPresented = true
                                viewModel.imageSource = .photoLibrary
                            }) {
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                            }
                            .padding(.top, 5)

                            Button(action: {
                                viewModel.isImagePickerPresented = true
                                viewModel.imageSource = .camera
                            }) {
                                Image(systemName: "camera")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25, height: 25)
                            }
                            .padding(.leading, 5)
                        }
                    }
                    .padding()

                    // 별명 입력 필드
                    InputFieldView(title: "별명", text: $viewModel.editedUserData.nickname)

                    // 이메일 입력 필드
                    InputFieldView(title: "이메일", text: $viewModel.editedUserData.email)

                    // 비밀번호 입력 필드
                    SecureInputFieldView(title: "비밀번호", text: $viewModel.editedUserData.password)

                    // 비밀번호 확인 필드
                    SecureInputFieldView(title: "비밀번호 확인", text: $viewModel.editedUserData.confirmPassword)

                    // 완료 및 취소 버튼
                    HStack {
                        Button(action: {
                            viewModel.saveChanges()
                        }) {
                            Text("완료")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)

                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("취소")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
        }
        .onAppear(){
            viewModel.fetchPage()
        }
        .onChange(of: viewModel.editing) { oldValue, newValue in
            if !viewModel.editing {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .sheet(isPresented: $viewModel.isImagePickerPresented) {
            ImagePicker(imageData: $viewModel.editedUserData.profilePhoto, sourceType: viewModel.imageSource)
        }
        Spacer()
    }
}


struct InputFieldView: View {
    let title: String
    @Binding var text: String

    var body: some View {
        HStack {
            TextField(title, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                )
        }
        .padding(.horizontal)
    }
}

struct SecureInputFieldView: View {
    let title: String
    @Binding var text: String

    var body: some View {
        HStack {
            SecureField(title, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                )
        }
        .padding(.horizontal)
    }
}

#Preview {
    AccountEditView(viewModel: AccountEditView.ViewModel())
}
