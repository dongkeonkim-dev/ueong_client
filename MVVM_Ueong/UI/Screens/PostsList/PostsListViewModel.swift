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
            fetchPage()
        }

        // 전체 페이지 데이터를 가져오는 함수
        func fetchPage(){
            Task{
                await fetchPosts() // 먼저 포스트를 가져옵니다.
                await fetchPhotosForPosts() // 포스트가 로드된 후에 사진을 가져옵니다.
            }
        }

        // 포스트 데이터를 가져오는 함수
        private func fetchPosts() async {
            do {
                let posts = try await postRepository.searchPosts(username: username, searchTerm: "")
                DispatchQueue.main.sync {
                    self.posts = posts
                    print("Successfully retrieved \(posts.count) posts.")
                }
            } catch {
                print("Error fetching posts: \(error)")
            }
        }

        // 모든 포스트의 사진 데이터를 비동기적으로 가져오는 함수
        private func fetchPhotosForPosts() async {
            for post in posts {
                do {
                    let photos = try await fetchPhotosForPost(postId: post.id)
                    DispatchQueue.main.async {
                        if let index = self.posts.firstIndex(where: { $0.id == post.id }) {
                            self.posts[index].photos = photos // 각 포스트에 대한 photos 업데이트
                        }
                    }
                } catch {
                    print("Error fetching photos for post \(post.id): \(error)")
                }
            }
        }

        // 특정 포스트의 사진 데이터를 가져오는 비동기 함수
        private func fetchPhotosForPost(postId: Int) async throws -> [Photo] {
            return try await photoRepository.getPhotosForPost(postId: postId)
        }
    }
}
