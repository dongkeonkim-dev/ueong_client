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
        
        var username: String
        var postId: Int
        
        let postRepository = PostRepository()
        let photoRepository = PhotoRepository()
        
        init(postId: Int) {
            self.username = "username1"
            self.postId = postId
        }
        
        func fetchPage() {
            Task {
                let post = try await postRepository.getPostById(username: username, postId: postId)
                let photos = try await photoRepository.getPhotosForPost(postId: postId)
                DispatchQueue.main.sync {
                    self.post = post
                    self.post.photos = photos
                    self.mapCoordinate = CLLocationCoordinate2D(latitude: post.latitude, longitude: post.longitude)
                }
            }
        }
    }
}
