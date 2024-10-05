//
//  SelectPostOption.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/26/24.
//

import SwiftUI

struct SelectPostOption: View {
    let viewModel : PostsList.ViewModel
    @State private var isARSelected: Bool = true
    @State private var selectedOption: String = "최신순"
    var body: some View {
        HStack(){
            Button(action:{
                isARSelected.toggle()
            }){
                Text("AR")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .fontWeight(isARSelected ? .semibold : .regular)
                    .foregroundColor(isARSelected ? .white : .blue)
            }
            .background(
                RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.3))
                    .fill(isARSelected ? Color.blue.opacity(0.6) : Color.gray.opacity(0.3))
                    
            )
            
            Spacer()
            
            Button(action: {
                selectedOption = "최신순"
                viewModel.sortBy = "createAt"
                viewModel.fetchPosts()
            }) {
                Text("최신순")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .foregroundColor(selectedOption == "최신순" ? .white : .blue)
                    .fontWeight(selectedOption == "최신순" ? .semibold : .regular)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedOption == "최신순" ? Color.blue.opacity(0.6) : Color.gray.opacity(0.3))
                    )
            }
            
            Button(action: {
                selectedOption = "가격순"
                viewModel.sortBy = "price"
                viewModel.fetchPosts()
            }) {
                Text("가격순")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .foregroundColor(selectedOption == "가격순" ? .white : .blue)
                    .fontWeight(selectedOption == "가격순" ? .semibold : .regular)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedOption == "가격순" ? Color.blue.opacity(0.6) : Color.gray.opacity(0.3))
                    )
            }

            Button(action: {
                selectedOption = "관심순"
                viewModel.sortBy = "favoriteCount"
                viewModel.fetchPosts()
            }) {
                Text("관심순")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .foregroundColor(selectedOption == "관심순" ? .white : .blue)
                    .fontWeight(selectedOption == "관심순" ? .semibold : .regular)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedOption == "관심순" ? Color.blue.opacity(0.6) : Color.gray.opacity(0.3))
                    )
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    SelectPostOption(viewModel: PostsList.ViewModel())
}
