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
        NavigationView {
            List(viewModel.Posts) { post in
                Text("\(post.name) - \(post.price, specifier: "%.2f")원")
            }
            
        }
    }
}

#Preview {
    PostsList(viewModel: PostsList.ViewModel())
}
