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
        @Published var PostDetail: PostDtl
        
        init() {
            // 예시 데이터 초기화
            self.PostDetail = PostDtl(id: UUID(), name: "", price: 0.0, isFavorite: false, description: "")
            // 예시 데이터 로드
            fetchPostDetail()
        }
        
        func fetchPostDetail() {
            //실제 데이터는 API나 로컬에서 가져올 수 있습니다.
            
            //예시 데이터
            self.PostDetail =
                PostDtl(id: UUID(), name: "iPhone 12", price: 600.0, isFavorite: false, description: "hahaha")
                
            
        }
    }
}
