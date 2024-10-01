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
        
        var username: String
        var postId: Int
        
        let postRepository = PostRepository()
        let photoRepository = PhotoRepository()
        let userRepository = UserRepository()
        let addressRepository = AddressRepository()
        
        init(postId: Int) {
            self.username = "username1"
            self.postId = postId
        }
        
        func fetchPage() {
            Task { @MainActor in
                self.post = try await postRepository.getPostById(username: username, postId: postId)
                self.post.photos = try await photoRepository.getPhotosForPost(postId: postId)
                self.writer = try await userRepository.getUserByUsername(username:post.writerUsername)
                self.siGuDong = try await addressRepository.getFullAddressById(emdId: post.emdId)
                self.mapCoordinate = CLLocationCoordinate2D(latitude: post.latitude, longitude: post.longitude)
            }
        }
    }
}
