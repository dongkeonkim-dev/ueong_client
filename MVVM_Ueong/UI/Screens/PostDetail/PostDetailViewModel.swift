//
//  PostDetailViewModel.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/25/24.
//
import Foundation
import MapKit

extension PostDetail {
  class ViewModel: ObservableObject {
    @Published var post: Post = Post()
    @Published var mapCoordinate : CLLocationCoordinate2D?
    @Published var siGuDong: String = "시구동"
    @Published var writer: User = User()
    
    var postId: Int
    
    let postRepository = PostRepository()
    let photoRepository = PhotoRepository()
    let userRepository = UserRepository()
    let addressRepository = AddressRepository()
    let favoriteRepository = FavoriteRepository()
    let arRepository = ArRepository()
    
    init(postId: Int) {
      self.postId = postId
      fetchPage()
    }
    
    func fetchPage() {
      Task { @MainActor in
        self.post = try await postRepository.getPostById(postId: postId)
        self.post.photos = try? await photoRepository
          .getPhotosByPostId(postId: postId)
        print("post.writerUsername: ", post.writerUsername)
        self.writer = try await userRepository.getUserByUsername(username:post.writerUsername)
        print("writer: ", writer)
        self.siGuDong = try await addressRepository.getFullAddress(emdId: post.emdId)
        self.mapCoordinate = CLLocationCoordinate2D(latitude: post.latitude, longitude: post.longitude)
          //                print(post)
        print("fetchPage API")
      }
    }
    
    func togglePostDetailFavorite() {
      Task { @MainActor in
        post.isFavorite.toggle()
        post.favoriteCount += post.isFavorite ? 1 : -1
        print(post)
      }
    }
      
    func getARFileByPostId() async -> AR? {
        do {
            return try await arRepository.getARFileByPostId(postId: postId)
        } catch {
            print("Failed to get AR file by postId: \(error)")
            return nil // 에러 발생 시 nil 반환 (필요에 따라 다르게 처리 가능)
        }
    }
      

  }
}

