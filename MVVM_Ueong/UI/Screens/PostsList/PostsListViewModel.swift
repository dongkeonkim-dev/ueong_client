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
    @Published var arOnly: Bool = true
    @Published var sortBy: String = "create_at" // 기본 정렬 기준
    @Published var searchTerm: String = ""
    @Published var isFetching = false // 네트워크 요청 중인지 여부
    
    let postRepository = PostRepository()
    let photoRepository = PhotoRepository()
    let myVillageRepository = MyVillageRepository()
    let favoriteRepository = FavoriteRepository()
    
    init() {
      Task{
        await fetchVillageList()
        await fetchPosts()
      }
    }
    
    func fetchVillageList() async{
      Task{ @MainActor in
        print("fetching villageList")
        self.myVillages = try await myVillageRepository.getMyVillages()
        print("myVillages 불러오기: \(myVillages)")
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
        //isFetching = true // 네트워크 작업 시작 표시
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
          arOnly: arOnly,
          sortBy: sortBy
        )
        
        await MainActor.run {
          self.posts = fetchedPosts
          self.isFetching = false
        }
        await fetchPhotosForPosts() // 포스트별 사진 로드
      } catch {
        
        await MainActor.run{
          self.isFetching = false
        }
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
      
      //postIds = post.map{in post post.id}
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
    
    func togglePostStatus(post: Post) {
      Task { @MainActor in
        do {
            // posts 배열에서 해당 포스트 찾기
          if let index = posts.firstIndex(where: { $0.id == post.id }) {
            let newStatus = post.status == "거래대기" ? "거래완료" : "거래대기"
            
              // API 호출
            let response = try await postRepository.changePostStatus(
              postId: post.id,
              status: newStatus
            )
            
              // 성공 시 로컬 상태 업데이트
            posts[index].status = newStatus
          }
        } catch {
          print("상태 변경 실패: \(error)")
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


