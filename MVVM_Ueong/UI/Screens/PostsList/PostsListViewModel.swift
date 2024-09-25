//
//  ProductsListViewModel.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//
import SwiftUI

extension PostsList {
    class ViewModel: ObservableObject {
        @Published var Posts: [Post] = []
        
        init() {
            // 예시 데이터 로드
            fetchProducts()
        }
        
        func fetchProducts() {
            //실제 데이터는 API나 로컬에서 가져올 수 있습니다.
            
            //예시 데이터
            self.Posts = [
                Post(id: UUID(), name: "iPhone 12", price: 600.0, isFavorite: false),
                Post(id: UUID(), name: "MacBook Pro", price: 1500.0, isFavorite: true)
            ]
        }
    }
}
