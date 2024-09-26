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
        var postImage: PostImage = PostImage(id: 1, postId: 1, image: "cat2")
        let postRepository = PostRepository()
        let imageRepository = ImageRepository()
        
        
        init() {
            // 예시 데이터 로드
            fetchPosts()
        }
        
        func fetchPosts() {
            //실제 데이터는 API나 로컬에서 가져올 수 있습니다.
         
            
            //예시 데이터
            self.posts = postRepository.getPostList()
            self.postImage = imageRepository.getImageById()
            
        }
        
        
    }
}
