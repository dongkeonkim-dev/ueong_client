//
//  FavoritesListViewModel.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//
//
import SwiftUI

extension FavoritesList {
    class ViewModel: ObservableObject{
        @Published var favoritePosts: [Post] = []
        let postRepository = PostRepository()
        let userId: Int
            
        init(userId: Int) {
            // 예시 좋아요 상품 로드
            self.userId = userId
            loadFavorites()
        }
            
        func loadFavorites() {
            self.favoritePosts = postRepository.getFavoriteList(userId: userId)
        }
        
    }
}
