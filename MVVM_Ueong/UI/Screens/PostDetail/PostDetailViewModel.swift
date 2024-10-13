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
        let favoriteRepository = FavoriteRepository()
        
        init(postId: Int) {
            self.username = "username1"
            self.postId = postId
        }
        
        func fetchPage() {
            Task { @MainActor in
                self.post = try await postRepository.getPostById(username: username, postId: postId)
                self.post.photos = try? await photoRepository.getPhotosForPost(postId: postId)
                self.writer = try await userRepository.getUserByUsername(username:post.writerUsername)
                self.siGuDong = try await addressRepository.getFullAddress(emdId: post.emdId)
                self.mapCoordinate = CLLocationCoordinate2D(latitude: post.latitude, longitude: post.longitude)
//                print(post)
            }
        }
        
        func toggleFavorite() {
            Task { @MainActor in
                // posts 배열에서 인덱스를 찾아서 수정합니다.
                    post.isFavorite.toggle()
                    post.favoriteCount += post.isFavorite ? 1 : -1
                    
                    do {
                        if post.isFavorite {
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
    }

