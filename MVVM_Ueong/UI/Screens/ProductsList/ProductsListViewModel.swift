//
//  ProductsListViewModel.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//
import SwiftUI

extension ProductsList {
    class ViewModel: ObservableObject {
        @Published var products: [Product] = []
        
        init() {
            // 예시 데이터 로드
            fetchProducts()
        }
        
        func fetchProducts() {
            //실제 데이터는 API나 로컬에서 가져올 수 있습니다.
            
            //예시 데이터
            self.products = [
                Product(id: UUID(), name: "iPhone 12", price: 600.0, isFavorite: false),
                Product(id: UUID(), name: "MacBook Pro", price: 1500.0, isFavorite: true)
            ]
        }
    }
}
