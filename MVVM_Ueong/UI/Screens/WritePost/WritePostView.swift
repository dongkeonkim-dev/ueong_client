//
//  WritePostView.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//
import SwiftUI

struct WritePostView: View {
    @ObservedObject var viewModel: WritePostView.ViewModel
    @FocusState private var isTitleFocused: Bool
    @FocusState private var isPriceFocused: Bool
    @FocusState private var isExplanationFocused: Bool

    var body: some View {
        ScrollView {
            VStack {
                // 사진 추가 버튼
                HStack {
                    Button(action: {}) {
                        HStack(alignment: .top) {
                            Image(systemName: "camera")
                                .font(.system(size: 30))
                                .foregroundColor(.blue)
                                .frame(width: 70, height: 70)
                                .background(Color.clear)
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))
                        }
                    }
                    Spacer()
                }
                .padding(.top, 30)

                // 제목 입력
                HStack {
                    VStack(alignment: .leading) {
                        Text("제목")
                        TextField("제목을 입력하세요", text: $viewModel.post.title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(isTitleFocused ? Color.black : Color.gray.opacity(0.5), lineWidth: 1)
                            )
                            .padding(.horizontal, 10)
                            .focused($isTitleFocused)
                    }
                    Spacer()
                }
                .padding(.top, 30)

                // 가격 입력
                HStack {
                    VStack(alignment: .leading) {
                        Text("가격")
                        TextField("가격을 입력하세요", value: $viewModel.post.price, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .overlay(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(isPriceFocused ? Color.black : Color.gray.opacity(0.5), lineWidth: 1)
                            )
                            .padding(.horizontal, 10)
                            .focused($isPriceFocused)
                    }
                    Spacer()
                }
                .padding(.top, 30)

                // 설명 입력
                HStack {
                    VStack(alignment: .leading) {
                        Text("자세한 설명")
                        TextField("게시글 내용을 작성해 주세요\n 신뢰할 수 있는 거래를 위해 자세히 적어주세요", text: $viewModel.post.text)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(height: 250)
                            .overlay(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(isExplanationFocused ? Color.black : Color.gray.opacity(0.5), lineWidth: 1)
                            )
                            .padding(.horizontal, 10)
                            .focused($isExplanationFocused)
                    }
                    Spacer()
                }
                .padding(.top, 30)

                // 거래 희망 장소
                HStack {
                    VStack(alignment: .leading) {
                        Text("거래 희망 장소")
                        TextField("단월동", text: $viewModel.post.locationDetail)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(isPriceFocused ? Color.black : Color.gray.opacity(0.5), lineWidth: 1)
                            )
                            .padding(.horizontal, 10)
                            .focused($isPriceFocused)
                    }
                    Spacer()
                }
                .padding(.top, 30)
            }
            .padding(.leading, 20)
            .navigationBarTitle("내 물건 팔기", displayMode: .inline)
            Spacer()
            
            AddButton()
                .padding(.top,20)
                .padding(.bottom,20)
        }
        
           
    
    }
}

struct AddButton: View {
    public var body: some View {
        VStack {
            Spacer()
            HStack {
                Button(action: {
                    // 완료 버튼 액션
                }) {
                    Text("작성 완료")
                        .font(.system(size: 20).weight(.bold))
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12).fill(Color.blue)
                )
                .padding(.horizontal)
                .foregroundColor(Color.white)
            }
        }
    }
}

#Preview {
    WritePostView(viewModel: WritePostView.ViewModel())
}

