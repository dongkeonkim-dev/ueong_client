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
    
    init(postId: Int) {
      self.postId = postId
      fetchPage()
    }
    
    func fetchPage() {
      Task { @MainActor in
        self.post = try await postRepository.getPostById(username: username, postId: postId)
        self.post.photos = try? await photoRepository
          .getPhotosByPostId(postId: postId)
        self.writer = try await userRepository.getUserByUsername(username:post.writerUsername)
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
  }
}

