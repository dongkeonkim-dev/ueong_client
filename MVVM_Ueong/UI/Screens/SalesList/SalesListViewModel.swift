//
//  SalesListViewModel.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//
import SwiftUI

extension SalesListView {
    class ViewModel: ObservableObject {
        @Published var myPosts: [Post] = []
        @Published var postsForSale: [Post] = []
        @Published var postsSold: [Post] = []
        let postRepository = PostRepository()
        let photoRepository = PhotoRepository()
        var username: String

        init() {
            // 예시 사용자 이름으로 설정
            self.username = "username1"
            fetchMyPosts()
        }

        func fetchMyPosts() {
            postRepository.getMyPosts(username: username) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let posts):
                        self?.myPosts = posts
                        self?.postsForSale = posts.filter { $0.status == "거래대기" }
                        self?.postsSold = posts.filter { $0.status == "거래완료" }
                        self?.fetchPhotosForPostsForSaleAndSold()
                        print("Successfully retrieved \(posts.count) posts.")
                    case .failure(let error):
                        print("Error fetching posts: \(error)")
                    }
                }
            }
        }

        private func fetchPhotos(for posts: [Post], updateHandler: @escaping ([Post]) -> Void) {
            var updatedPosts = posts
            for (index, post) in posts.enumerated() {
                photoRepository.getPhotosForPost(postId: post.id) { [weak self] photos in
                    DispatchQueue.main.async {
                        updatedPosts[index].photos = photos
                        updateHandler(updatedPosts)
                    }
                }
            }
        }

        private func fetchPhotosForPostsForSaleAndSold() {
            // 판매중 포스트에 대한 사진 업데이트
            fetchPhotos(for: postsForSale) { [weak self] updatedPosts in
                self?.postsForSale = updatedPosts
            }

            // 판매완료 포스트에 대한 사진 업데이트
            fetchPhotos(for: postsSold) { [weak self] updatedPosts in
                self?.postsSold = updatedPosts
            }
        }
    }
}


