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
            Post(id:1, title:"자전거", price:3000, isFavorite: false, text: "hahahah"),
            Post(id:2, title:"자전거", price:3000, isFavorite: false, text: "soososososo")
        ]
        return posts
    }
    
    func getPostSold(userId:Int) -> [Post] {
        // MySQL에서 데이터 받아오는 로직
        
        let posts = [
            Post(id:3, title:"자전거", price:3000, isFavorite: false, text: "gogogogoogog"),
            Post(id:4, title:"자전거", price:3000, isFavorite: false, text:" hohohohohoh")
        ]
        return posts
    }
    
    func getPostList() -> [Post] {
        // MySQL에서 데이터 받아오는 로직
        
        let posts = [
            Post(id:5, title:"자전거", price:3000, isFavorite: false, text: "hahahah"),
            Post(id:6, title:"자전거", price:3000, isFavorite: false, text: "soososososo")
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
    
    func getFavoriteList(userId:Int) -> [Post] {
        // MySQL에서 데이터 받아오는 로직
        
        let posts = [
            Post(id:8, title:"자전거", price:3000, isFavorite: false, text: "hahahah"),
            Post(id:9, title:"자전거", price:3000, isFavorite: false, text: "soososososo")
        ]
        return posts
    }
}
