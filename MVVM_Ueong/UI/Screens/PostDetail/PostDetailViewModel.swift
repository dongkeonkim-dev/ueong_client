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
        @Published var PostDetail: PostDtl? = PostDtl(id: 100, name: "", price: 0.0, isFavorite: false, description: "")
        let postID: Int
        
        init(postID: Int) {
            // 예시 데이터 초기화
            self.postID = postID
            
            // 예시 데이터 로드
            loadPostDetail()
            
        }
        
        func loadPostDetail() {
         
            

        }
        
    }
}
