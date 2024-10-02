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
        @Published var myVillages : [MyVillage] = []
        @Published var selection: MyVillage? = nil// 기본값을 사용하여 초기화
        @Published var sortBy: String = "create_at" // 기본 정렬 기준
        
        let username: String
        let postRepository = PostRepository()
        let photoRepository = PhotoRepository()
        let myVillageRepository = MyVillageRepository()

        init() {
            self.username = "username1"
            Task{
                fetchVillageList()
                fetchPosts()
            }
        }

        func fetchVillageList(){
            Task{ @MainActor in
                self.myVillages = try await myVillageRepository.getMyVillagesByUsername(username: username)
                self.selection = myVillages[0]
            }
        }
        // 전체 페이지 데이터를 가져오는 함수
        func fetchPosts(){
            Task{ @MainActor in
                self.posts = try await postRepository.searchPosts(
                    username: username,
                    village: selection?.id ?? 0,
                    searchTerm: "",
                    sortBy:sortBy)
                await fetchPhotosForPosts() // 포스트가 로드된 후에 사진을 가져옵니다.
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
