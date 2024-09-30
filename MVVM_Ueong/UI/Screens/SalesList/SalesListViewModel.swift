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
            fetchPage()
        }

        func fetchPage(){
            Task{
                await fetchMyPosts()
                await fetchPhotos(for: &postsForSale)
                await fetchPhotos(for: &postsSold)
            }
        }
        func fetchMyPosts() async {
            do {
                let posts = try await postRepository.getMyPosts(username: username)
                myPosts = posts
                postsForSale = posts.filter { $0.status == "거래대기" }
                postsSold = posts.filter { $0.status == "거래완료" }
                print("Successfully retrieved \(posts.count) posts.")
                
            } catch {
                print("Error fetching posts: \(error)")
            }
        }

        private func fetchPhotos(for posts: inout [Post]) async {
            for index in posts.indices {
                do {
                    let photos = try await photoRepository.getPhotosForPost(postId: posts[index].id)
                    posts[index].photos = photos // 각 포스트에 대한 photos 업데이트
                } catch {
                    print("Error fetching photos for post \(posts[index].id): \(error)")
                }
            }
        }
    }
}
