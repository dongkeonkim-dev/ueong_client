//
//  PostDetailViewModel.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/25/24.
//

import Foundation

import SwiftUI

extension PostDetail {
    class ViewModel: ObservableObject {
        @Published var PostDetail: PostDtl?
        let postID: Int
        
        init(postID: Int) {
            // 예시 데이터 초기화
            self.PostDetail = PostDtl(id: 1, name: "", price: 0.0, isFavorite: false, description: "")
            self.postID = postID
            
            // 예시 데이터 로드
            fetchPostDetail()
            
        }
        
        func fetchPostDetail() {
         
            

        }
        
        // UUID로 데이터를 찾는 함수
        func findPostById(postId: Int, in posts: [PostDtl]) -> PostDtl? {
            return posts.first(where: { $0.id == postId })
        }
    }
}
