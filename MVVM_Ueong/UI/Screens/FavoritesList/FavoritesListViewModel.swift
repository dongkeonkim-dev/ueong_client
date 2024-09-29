//
//  FavoritesListViewModel.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//
//
import SwiftUI

extension FavoritesListView {
    class ViewModel: ObservableObject {
        @Published var favoritePosts: [Post] = []
        let postRepository = PostRepository()
        let photoRepository = PhotoRepository()
        var username: String

        init(userId: Int) {
            // 예시 좋아요 상품 로드
            self.username = "username1"
            loadFavorites()
        }

        func loadFavorites() {
            postRepository.getFavoriteList(username: username) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let posts):
                        self?.favoritePosts = posts // UI 업데이트는 메인 스레드에서
                        self?.fetchPhotosForPosts()
                        print("Successfully retrieved \(posts.count) posts.")
                    case .failure(let error):
                        print("Error fetching posts: \(error)")
                    }
                }
            }
        }

        private func fetchPhotosForPosts() {
            for index in favoritePosts.indices {
                let postId = favoritePosts[index].id
                photoRepository.getPhotosForPost(postId: postId) { [weak self] photos in
                    DispatchQueue.main.async {
                        self?.favoritePosts[index].photos = photos // 각 포스트에 대한 photos 업데이트
                    }
                }
            }
        }
    }
}

