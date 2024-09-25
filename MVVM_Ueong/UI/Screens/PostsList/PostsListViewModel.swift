//
//  ProductsListViewModel.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//
import SwiftUI

extension PostsList {
    class ViewModel: ObservableObject {
        @Published var posts: [Post] = []
        
        init() {
            // 예시 데이터 로드
            fetchPosts()
        }
        
        func fetchPosts() {
            //실제 데이터는 API나 로컬에서 가져올 수 있습니다.
         
            
            //예시 데이터
            self.posts = [
                Post(id: 1, name: "iPhone 12", price: 600.0, isFavorite: false),
                Post(id: 2, name: "MacBook Pro", price: 1500.0, isFavorite: true)
            ]
        }
        
        
    }
}
