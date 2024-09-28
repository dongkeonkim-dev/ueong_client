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
        let username: String
        let postRepository = PostRepository()
        let photoRepository = PhotoRepository()
        
        
        init() {
            self.username = "username1"
            fetchPosts()
        }
        
        private func fetchPosts() {
            postRepository.searchPosts(username: username, searchTerm: "") { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let posts):
                        self?.posts = posts // UI 업데이트는 메인 스레드에서
                        self?.fetchPhotosForPosts()
                        print("Successfully retrieved \(posts.count) posts.")
                    case .failure(let error):
                        print("Error fetching posts: \(error)")
                    }
                }
            }
        }
        
        private func fetchPhotosForPosts() {
            for post in posts {
                photoRepository.getPhotosForPost(postId: post.id) { [weak self] photos in
                    DispatchQueue.main.async {
                        if let index = self?.posts.firstIndex(where: { $0.id == post.id }) {
                            self?.posts[index].photos = photos // 각 포스트에 대한 photos 업데이트
                        }
                    }
                }
            }
        }
    }
}
