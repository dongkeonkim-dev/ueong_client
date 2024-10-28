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
    let myVillageRepository = MyVillageRepository()
    let favoriteRepository = FavoriteRepository()
    
    init() {
      Task{
        print("PostList init")
        fetchVillageList()
      }
    }
    
    func fetchVillageList(){
      Task{ @MainActor in
        self.myVillages = try await myVillageRepository.getMyVillages()
        guard myVillages.count > 0 else {
          self.selection = Emd(for: .noVillage)
          
          return
        }
        self.selection = myVillages[0]
      }
    }
    
    func fetchPosts() async {
      guard !isFetching else {
        print("Already fetching, request ignored.")
        return
      }
      print("fetching PostsList")
      
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
    
    
    func fetchPhotosForPosts() async {
      await withThrowingTaskGroup(of: (Int, [Photo]).self) { group in
        for post in posts {
          group.addTask {
            let photos = try await self.photoRepository
              .getPhotosByPostId(postId: post.id)
            return (post.id, photos)
          }
        }
        
        do {
          for try await (postId, photos) in group {
            await MainActor.run {
              if let index = self.posts.firstIndex(where: { $0.id == postId }) {
                self.posts[index].photos = photos
                print("Updated post \(postId) with \(photos.count) photos")
              }
            }
          }
        } catch {
          print("Error fetching photos: \(error.localizedDescription)")
        }
      }
    }
      //각 post의 좋아요를 관리하는 함수
    func togglePostsListFavorite(post: Post) {
      Task { @MainActor in
          // posts 배열에서 인덱스를 찾아서 수정합니다.
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
          posts[index].isFavorite.toggle()
          posts[index].favoriteCount += posts[index].isFavorite ? 1 : -1
          
          do {
            if posts[index].isFavorite {
              _ = try await favoriteRepository.addFavorite(postId: post.id)
            } else {
              _ = try await favoriteRepository.deleteFavorite(postId: post.id)
            }
          } catch {
            print("Error updating favorite status for post \(post.id): \(error)")
          }
        }
      }
    }
    
    func inactivatePost(post: Post) {
      Task { @MainActor in
        _ = try await postRepository.inactivatePost(postId: post.id)
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
          posts[index].isActive.toggle()
        }
      }
    }
    
    func addPostRow(post: Post) {
      posts.insert(post, at:0)
    }
  }
}


