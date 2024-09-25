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
            fetchPosts()
        }
        
        func fetchPosts() {
            //실제 데이터는 API나 로컬에서 가져올 수 있습니다.
            self.Posts = convertPostDtlToPost(mockData_Post)
            
            //예시 데이터
            self.Posts = [
                Post(id: 1, name: "iPhone 12", price: 600.0, isFavorite: false),
                Post(id: 2, name: "MacBook Pro", price: 1500.0, isFavorite: true)
            ]
        }
        
        // PostDtl 배열을 Post 배열로 변환하는 함수
        func convertPostDtlToPost(_ postDtls: [PostDtl]) -> [Post] {
            return postDtls.map { postDtl in
                Post(id: postDtl.id, name: postDtl.name, price: postDtl.price, isFavorite: postDtl.isFavorite)
            }
        }
    }
}
