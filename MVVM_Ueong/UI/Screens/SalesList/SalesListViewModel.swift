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
    let favoriteRepository = FavoriteRepository()
    
    init() {
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
        let posts = try await postRepository.getMyPosts()
        myPosts = posts
        postsForSale = posts.filter { $0.status == "거래대기" }
        postsSold = posts.filter { $0.status == "거래완료" }
        print("Successfully retrieved \(posts.count) posts.")
        
      } catch {
          //                print("Error fetching posts: \(error)")
      }
    }
    
    private func fetchPhotos(for posts: inout [Post]) async {
      for index in posts.indices {
        do {
          let photos = try await photoRepository
            .getPhotosByPostId(postId: posts[index].id)
          posts[index].photos = photos // 각 포스트에 대한 photos 업데이트
        } catch {
          print("Error fetching photos for post \(posts[index].id): \(error)")
        }
      }
    }
    func togglePostStatus(post: Post) {
      Task { @MainActor in
        do {
          let newStatus = post.status == "거래대기" ? "거래완료" : "거래대기"
          
            // API 호출
          let response = try await postRepository.changePostStatus(
            postId: post.id,
            status: newStatus
          )
          
            // 성공 시 로컬 상태 업데이트
          if let forSaleIndex = postsForSale.firstIndex(where: { $0.id == post.id }) {
              // 거래대기 -> 거래완료
            var updatedPost = postsForSale.remove(at: forSaleIndex)
            updatedPost.status = newStatus
            postsSold.insert(updatedPost, at: 0)
          } else if let soldIndex = postsSold.firstIndex(where: { $0.id == post.id }) {
              // 거래완료 -> 거래대기
            var updatedPost = postsSold.remove(at: soldIndex)
            updatedPost.status = newStatus
            postsForSale.insert(updatedPost, at: 0)
          }
          
            // myPosts 배열도 업데이트
          if let myPostIndex = myPosts.firstIndex(where: { $0.id == post.id }) {
            myPosts[myPostIndex].status = newStatus
          }
          
        } catch {
          print("상태 변경 실패: \(error)")
        }
      }
      
    }
    func toggleFavorite(post: Post, type: PostStatus){
      Task { @MainActor in
          // 타입에 따라 적절한 포스트 배열 선택
        switch type {
          case .forSale:
              // posts 배열에서 인덱스를 찾아서 수정합니다.
            if let index = postsForSale.firstIndex(where: { $0.id == post.id }) {
              postsForSale[index].isFavorite.toggle()
              postsForSale[index].favoriteCount += postsForSale[index].isFavorite ? 1 : -1
              
              do {
                if postsForSale[index].isFavorite {
                  try await favoriteRepository.addFavorite(postId: post.id)
                } else {
                  try await favoriteRepository.deleteFavorite(postId: post.id)
                }
              } catch {
                print("Error updating favorite status for post \(post.id): \(error)")
              }
            }
          case .sold:
              // posts 배열에서 인덱스를 찾아서 수정합니다.
            if let index = postsSold.firstIndex(where: { $0.id == post.id }) {
              postsSold[index].isFavorite.toggle()
              postsSold[index].favoriteCount += postsSold[index].isFavorite ? 1 : -1
              
              do {
                if postsSold[index].isFavorite {
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
    }
    func inactivatePost(post: Post) {
      Task { @MainActor in
        do {
          _ = try await postRepository.inactivatePost(postId: post.id)
          
            // 각 배열에서 해당 포스트 찾아서 업데이트
          if let forSaleIndex = postsForSale.firstIndex(where: { $0.id == post.id }) {
            postsForSale[forSaleIndex].isActive = false
            postsForSale.remove(at: forSaleIndex)
          }
          
          if let soldIndex = postsSold.firstIndex(where: { $0.id == post.id }) {
            postsSold[soldIndex].isActive = false
            postsSold.remove(at: soldIndex)
          }
          
          if let myPostIndex = myPosts.firstIndex(where: { $0.id == post.id }) {
            myPosts[myPostIndex].isActive = false
          }
          
        } catch {
          print("게시글 비활성화 실패: \(error)")
        }
      }
    }
  }
}
enum PostStatus {
  case forSale
  case sold
}
