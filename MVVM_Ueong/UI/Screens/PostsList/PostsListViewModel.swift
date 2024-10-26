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
        @Published var myVillages : [Emd] = []
        @Published var selection: Emd? = nil// 기본값을 사용하여 초기화
        @Published var sortBy: String = "create_at" // 기본 정렬 기준
        @Published var searchTerm: String = ""
        @Published var isFetching = false // 네트워크 요청 중인지 여부

        let postRepository = PostRepository()
        let photoRepository = PhotoRepository()
        let emdRepository = EmdRepository()
        let favoriteRepository = FavoriteRepository()

        init() {
            print("PostsListViewModel 생성")
            Task{
                fetchVillageList()
                await fetchPosts()
            }
            
        }

        func fetchVillageList(){
            Task{ @MainActor in
                self.myVillages = try await emdRepository.getMyVillages(username: username)
                self.selection = myVillages[0]
            }
        }
        
        func fetchPosts() async {
            guard !isFetching else {
                print("Already fetching, request ignored.")
                return
            }
            
            Task{ @MainActor in
                isFetching = true // 네트워크 작업 시작 표시
            }
            // `defer`로 항상 실행될 코드를 보장
            defer {
                Task{ @MainActor in
                    isFetching = false // 네트워크 작업 종료 표시
                }
            }

            do {
                await MainActor.run { self.posts.removeAll() } // 초기화
                let fetchedPosts = try await postRepository.searchPosts(
                    username: username,
                    village: selection?.id ?? 0,
                    searchTerm: searchTerm,
                    sortBy: sortBy
                )

                await MainActor.run {
                    self.posts = fetchedPosts
                }

                await fetchPhotosForPosts() // 포스트별 사진 로드
            } catch {
                print("Error fetching posts: \(error.localizedDescription)")
            }
        }


        private func fetchPhotosForPosts() async {
            await withThrowingTaskGroup(of: (Int, [Photo]).self) { group in
                // 모든 포스트에 대해 비동기적으로 사진 가져오기
                for post in posts {
                    group.addTask {
                        let photos = try await self.photoRepository.getPhotosForPost(postId: post.id)
                        return (post.id, photos) // 포스트 ID와 사진 배열 반환
                    }
                }

                // 각 작업의 결과 처리
                do {
                    for try await (postId, photos) in group {
                        await MainActor.run {
                            if let index = self.posts.firstIndex(where: { $0.id == postId }) {
                                self.posts[index].photos = photos // 포스트에 사진 업데이트
                            }
                        }
                    }
                } catch {
                    print("Error fetching photos: \(error.localizedDescription)")
                }
            }
        }


        
        //각 post의 좋아요를 관리하는 함수
        func toggleFavorite(post: Post) {
            Task { @MainActor in
                // posts 배열에서 인덱스를 찾아서 수정합니다.
                if let index = posts.firstIndex(where: { $0.id == post.id }) {
                    posts[index].isFavorite.toggle()
                    posts[index].favoriteCount += posts[index].isFavorite ? 1 : -1
                    
                    do {
                        if posts[index].isFavorite {
                            try await favoriteRepository.addFavorite(postId: post.id, username: username)
                        } else {
                            try await favoriteRepository.deleteFavorite(postId: post.id, username: username)
                        }
                    } catch {
                        print("Error updating favorite status for post \(post.id): \(error)")
                    }
                }
            }
        }
//        func fetchPosts() async{
//            Task{ @MainActor in
//                self.posts.removeAll()
//                self.posts = try await postRepository.searchPosts(
//                    username: username,
//                    village: selection?.id ?? 0,
//                    searchTerm: searchTerm,
//                    sortBy:sortBy)
//                await fetchPhotosForPosts() // 포스트가 로드된 후에 사진을 가져옵니다.
//            }
//        }
//        // 모든 포스트의 사진 데이터를 비동기적으로 가져오는 함수
//        private func fetchPhotosForPosts() async {
//            for post in posts {
//                do {
//                    let photos = try await photoRepository.getPhotosForPost(postId: post.id)
//                    DispatchQueue.main.async {
//                        if let index = self.posts.firstIndex(where: { $0.id == post.id }) {
//                            self.posts[index].photos = photos // 각 포스트에 대한 photos 업데이트
//                        }
//                    }
//                } catch {
//                    print("Error fetching photos for post \(post.id): \(error)")
//                }
//            }
//        }
        
        
        

    }
}


