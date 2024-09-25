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
        let postID: UUID
        
        init(postID: UUID) {
            // 예시 데이터 초기화
            self.PostDetail = PostDtl(id: UUID(), name: "", price: 0.0, isFavorite: false, description: "")
            self.postID = postID
            
            // 예시 데이터 로드
            fetchPostDetail()
            
        }
        
        func fetchPostDetail() {
            //실제 데이터는 API나 로컬에서 가져올 수 있습니다.
            self.PostDetail = findPostById(postId: postID, in: mockData_Post)
            

        }
        
        // UUID로 데이터를 찾는 함수
        func findPostById(postId: UUID, in posts: [PostDtl]) -> PostDtl? {
            return posts.first(where: { $0.id == postId })
        }
    }
}
