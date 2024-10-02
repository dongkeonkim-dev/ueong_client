//
//  SearchPost.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 10/2/24.
//
import SwiftUI

struct SearchPost: View {
    @ObservedObject var sViewModel: SearchPost.ViewModel
    @ObservedObject var pViewModel: PostsList.ViewModel
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isSearchFieldFocused: Bool

    var body: some View {
        VStack() {
            // 검색어 입력 필드
            HStack {
                Button(action:{
                    presentationMode.wrappedValue.dismiss()
                }){
                    HStack{
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 21, weight: .medium))
                        Text("Back")
                            .padding(.leading,-2)
                    }
                    .padding(.leading,-8)
                }
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.blue)
                    TextField("검색어 입력", text: $sViewModel.searchTerm)
                        .font(.system(size: 15))
                        .textFieldStyle(PlainTextFieldStyle())
                        .frame(height: 18)
                        .focused($isSearchFieldFocused)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.3))
                ).padding(.leading,5)
                Button(action: {
                    pViewModel.searchTerm = sViewModel.searchTerm
                    presentationMode.wrappedValue.dismiss()
                    pViewModel.fetchPosts()
                }) {
                    Text("검색")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.trailing)
                
            }
            .padding(.horizontal)
            .background(Color.white) // 배경색을 추가해서 제목처럼 보이게 설정
            
            // 나머지 검색 결과 리스트 등
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(sViewModel.histories) { history in
                        Button(action:{
                            sViewModel.searchTerm = history.searchTerm
                            pViewModel.searchTerm = history.searchTerm
                            presentationMode.wrappedValue.dismiss()
                            pViewModel.fetchPosts()
                        }){
                            Text(history.searchTerm)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }.padding(20)
            }
            Spacer()
        }
        .navigationBarHidden(true)
        .onAppear {
            isSearchFieldFocused = true
            sViewModel.fetchSearchHistory()
        }
    }
}


#Preview {
    SearchPost(sViewModel: SearchPost.ViewModel(), pViewModel: PostsList.ViewModel())
}
