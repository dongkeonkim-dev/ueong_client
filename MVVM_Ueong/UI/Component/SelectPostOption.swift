//
//  SelectPostOption.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/26/24.
//

import SwiftUI

struct SelectPostOption: View {
    let viewModel : PostsList.ViewModel
    var body: some View {
        HStack(){
            Button(action:{
                viewModel.sortBy = "createAt"
                viewModel.fetchPosts()
            }){
                Text("전체")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
            }
            .background(
                RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.3))
            )
            
            
            Button(action:{}){
                Text("AR")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
            }
            .background(
                RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.3))
            )
            
            Button(action:{
                viewModel.sortBy = "price"
                viewModel.fetchPosts()
            }){
                Text("가격순")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
            }
            .background(
                RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.3))
            )
            
            Button(action:{
                viewModel.sortBy = "favoriteCount"
                viewModel.fetchPosts()
            }){
                Text("관심순")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
            }
            .background(
                RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.3))
            )
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    SelectPostOption(viewModel: PostsList.ViewModel())
}
