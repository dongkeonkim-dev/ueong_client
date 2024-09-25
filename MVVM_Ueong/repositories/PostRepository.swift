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
            Post(id:1, name:"자전거", price:3000, isFavorite: false),
            Post(id:2, name:"자전거", price:3000, isFavorite: false)
        ]
        return posts
    }
    
    func getPostSold(userId:Int) -> [Post] {
        // MySQL에서 데이터 받아오는 로직
        
        let posts = [
            Post(id:3, name:"자전거", price:3000, isFavorite: false),
            Post(id:4, name:"자전거", price:3000, isFavorite: false)
        ]
        return posts
    }
}

