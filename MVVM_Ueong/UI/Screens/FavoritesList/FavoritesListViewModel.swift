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
    let favoriteRepository = FavoriteRepository()
    
    init() {
      print("FavoritesListViewModel 생성")
    }
    
    func fetchPage(){
      Task{
        await loadFavorites()
        await fetchPhotosForPosts()
      }
    }
    
      // 좋아요 목록을 불러오는 함수
    private func loadFavorites() async{
      do {
        let posts = try await postRepository.getFavoriteList()
        DispatchQueue.main.sync {
          self.favoritePosts = posts
          print("Successfully retrieved \(posts.count) posts.")
        }
        await fetchPhotosForPosts()
      } catch {
        print("Error fetching favorite posts: \(error)")
      }
    }
    
      // 모든 좋아요 포스트에 대한 사진 데이터를 가져오는 함수
    private func fetchPhotosForPosts() async {
      for index in favoritePosts.indices {
        let postId = favoritePosts[index].id
        do {
          let photos = try await photoRepository
            .getPhotosByPostId(postId: postId)
          DispatchQueue.main.async {
            self.favoritePosts[index].photos = photos // 각 포스트에 대한 photos 업데이트
          }
        } catch {
          print("Error fetching photos for post \(postId): \(error)")
        }
      }
    }
    
    func toggleFavorite(post: Post) {
      Task { @MainActor in
          // posts 배열에서 인덱스를 찾아서 수정합니다.
        if let index = favoritePosts.firstIndex(where: { $0.id == post.id }) {
          favoritePosts[index].isFavorite.toggle()
          favoritePosts[index].favoriteCount += favoritePosts[index].isFavorite ? 1 : -1
          
          do {
            if favoritePosts[index].isFavorite {
              try await favoriteRepository.addFavorite(postId: post.id)
            } else {
              try await favoriteRepository.deleteFavorite(postId: post.id)
            }
          } catch {
            print("Error updating favorite status for post \(post.id): \(error)")
          }
        }
      }
    }
    func togglePostStatus(post: Post) {
      Task { @MainActor in
        do {
            // posts 배열에서 해당 포스트 찾기
          if let index = favoritePosts.firstIndex(where: { $0.id == post.id }) {
            let newStatus = post.status == "거래대기" ? "거래완료" : "거래대기"
            
              // API 호출
            let response = try await postRepository.changePostStatus(
              postId: post.id,
              status: newStatus
            )
            
              // 성공 시 로컬 상태 업데이트
            favoritePosts[index].status = newStatus
          }
        } catch {
          print("상태 변경 실패: \(error)")
        }
      }
    }
    func inactivatePost(post: Post) {
      Task { @MainActor in
        do {
            // API 호출
          _ = try await postRepository.inactivatePost(postId: post.id)
          
            // favoritePosts 배열에서 해당 포스트 찾아서 업데이트
          if let index = favoritePosts.firstIndex(where: { $0.id == post.id }) {
            favoritePosts[index].isActive = false
            favoritePosts.remove(at: index)  // 비활성화된 포스트 제거
          }
          
        } catch {
          print("게시글 비활성화 실패: \(error)")
        }
      }
    }
  }
}

