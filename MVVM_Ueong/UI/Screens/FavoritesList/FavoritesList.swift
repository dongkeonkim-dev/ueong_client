//
//  FavoritesList.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//

import SwiftUI

struct FavoritesList: View {
    @ObservedObject var viewModel: FavoritesList.ViewModel
        
        var body: some View {
            NavigationView {
                List(viewModel.favoritePosts) { post in
                    Text("\(post.name) - \(post.price, specifier: "%.2f")원")
                }
            
            }
        }
}

#Preview {
    FavoritesList(viewModel: FavoritesList.ViewModel())
}
