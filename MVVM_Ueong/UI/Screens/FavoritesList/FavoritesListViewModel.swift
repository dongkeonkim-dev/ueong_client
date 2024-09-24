//
//  FavoritesListViewModel.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//

import SwiftUI

extension FavoritesList {
    class ViewModel: ObservableObject{
        @Published var favoriteProducts: [Product] = []
            
        init() {
            // 예시 좋아요 상품 로드
            loadFavorites()
        }
            
        func loadFavorites() {
            self.favoriteProducts = [
                Product(id: UUID(), name: "MacBook Pro", price: 1500.0,isFavorite: true)
            ]
        }
        
    }
}
