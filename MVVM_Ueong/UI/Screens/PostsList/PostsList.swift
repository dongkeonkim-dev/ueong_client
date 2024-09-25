//
//  ProductsList.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//

import SwiftUI

struct PostsList: View {
    @ObservedObject var viewModel: PostsList.ViewModel
    
    var body: some View {
        VStack(spacing: 30){
            
            NavigationView {
                List(viewModel.posts) { post in
                    NavigationLink(
                        destination: PostDetail(viewModel: PostDetail.ViewModel(postID: post.id))
                    ) {
                        Text("\(post.title) - \(post.price, specifier: "%.2f")원")
                    }
                }
                
            }
        }
    }
}

#Preview {
    PostsList(viewModel: PostsList.ViewModel())
}
