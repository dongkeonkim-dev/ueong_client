//
//  PostRepository.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//

import Foundation

class PostRepository {
    func getPostForSale(userId:Int) -> [Post] {
        // MySQL에서 데이터 받아오는 로직
        
        let posts = [
           Post(
                id: 9,
                title: "자전거",
                category: 1,
                price: 3000.0,
                emdId: 1,
                latitude: 37.5,
                longitude: 160.0,
                locationDetail: "아무데나",
                createAt: Date(), // Date()로 초기화
                isFavorite: false,
                text: "soososososo",
                photos: [
                    Photo(id: 1, postId: 1, url: "cat1.jpg") // 여기에 사진의 URL을 적어주세요
                ]
            ), Post(
                id: 9,
                title: "자전거",
                category: 1,
                price: 3000.0,
                emdId: 1,
                latitude: 37.5,
                longitude: 160.0,
                locationDetail: "아무데나",
                createAt: Date(), // Date()로 초기화
                isFavorite: false,
                text: "soososososo",
                photos: [
                    Photo(id: 1, postId: 1, url: "cat1.jpg") // 여기에 사진의 URL을 적어주세요
                ]
            )
        ]
        return posts
    }
    
    func getPostSold(userId:Int) -> [Post] {
        // MySQL에서 데이터 받아오는 로직
        
        let posts = [
            Post(
                 id: 9,
                 title: "자전거",
                 category: 1,
                 price: 3000.0,
                 emdId: 1,
                 latitude: 37.5,
                 longitude: 160.0,
                 locationDetail: "아무데나",
                 createAt: Date(), // Date()로 초기화
                 isFavorite: false,
                 text: "soososososo",
                 photos: [
                     Photo(id: 1, postId: 1, url: "cat1.jpg") // 여기에 사진의 URL을 적어주세요
                 ]
             ), Post(
                 id: 9,
                 title: "자전거",
                 category: 1,
                 price: 3000.0,
                 emdId: 1,
                 latitude: 37.5,
                 longitude: 160.0,
                 locationDetail: "아무데나",
                 createAt: Date(), // Date()로 초기화
                 isFavorite: false,
                 text: "soososososo",
                 photos: [
                     Photo(id: 1, postId: 1, url: "cat1.jpg") // 여기에 사진의 URL을 적어주세요
                 ]
             )
         ]
        return posts
    }
    
    func searchPosts(username: String, searchTerm: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        APICall.shared.get("post/search", parameters: ["username":username], queryParameters: ["searchTerm":searchTerm]) { (result: Result<[Post], Error>) in
                switch result {
                case .success(let posts):
                    print("Posts retrieved successfully: \(posts.count) posts found.")
                    completion(.success(posts))
                case .failure(let error):
                    print("Error fetching posts: \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    func getPostDetail(userId:Int) -> Post {
        // MySQL에서 데이터 받아오는 로직
        
        let posts = Post(
            id: 9,
            title: "자전거",
            category: 1,
            price: 3000.0,
            emdId: 1,
            latitude: 37.5,
            longitude: 160.0,
            locationDetail: "아무데나",
            createAt: Date(), // Date()로 초기화
            isFavorite: false,
            text: "soososososo",
            photos: [
                Photo(id: 1, postId: 1, url: "cat1.jpg") // 여기에 사진의 URL을 적어주세요
            ]
        )
      
        return posts
    }
    
    func getFavoriteList(userId:Int) -> [Post] {
        // MySQL에서 데이터 받아오는 로직
        
        let posts = [
            Post(
                 id: 9,
                 title: "자전거",
                 category: 1,
                 price: 3000.0,
                 emdId: 1,
                 latitude: 37.5,
                 longitude: 160.0,
                 locationDetail: "아무데나",
                 createAt: Date(), // Date()로 초기화
                 isFavorite: false,
                 text: "soososososo",
                 photos: [
                     Photo(id: 1, postId: 1, url: "cat1.jpg") // 여기에 사진의 URL을 적어주세요
                 ]
             ), Post(
                 id: 9,
                 title: "자전거",
                 category: 1,
                 price: 3000.0,
                 emdId: 1,
                 latitude: 37.5,
                 longitude: 160.0,
                 locationDetail: "아무데나",
                 createAt: Date(), // Date()로 초기화
                 isFavorite: false,
                 text: "soososososo",
                 photos: [
                     Photo(id: 1, postId: 1, url: "cat1.jpg") // 여기에 사진의 URL을 적어주세요
                 ]
             )
         ]
        return posts
    }
}

