//
//  PostRepository.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//

import Foundation

class PostRepository {
    let dateFormatter: ISO8601DateFormatter

        init() {
            self.dateFormatter = ISO8601DateFormatter()
            self.dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        }
    
    
    
    func getPostForSale(userId:Int) -> [Post] {
        // MySQL에서 데이터 받아오는 로직
        
        let posts = [
            Post(id:1, title:"자전거", category:1, price:3000, emdId:1, latitude: 37.5665, longitude: 126.9780, locationDetail: "00건물 2층", text: "중고제품에 대한 설명글", createdAt: dateFormatter.date(from: "2024-09-25T12:34:56Z")!, isFavorite: false),
            Post(id:2, title:"자전거", category:1, price:3000, emdId:1, latitude: 37.5665, longitude: 126.9780, locationDetail: "00건물 2층", text: "중고제품에 대한 설명글", createdAt: dateFormatter.date(from: "2024-09-25T12:34:56Z")!, isFavorite: false)
        ]
        return posts
    }
    
    func getPostSold(userId:Int) -> [Post] {
        // MySQL에서 데이터 받아오는 로직
        
        let posts = [
            Post(id:3, title:"자전거", category:1, price:3000, emdId:1, latitude: 37.5665, longitude: 126.9780, locationDetail: "00건물 2층", text: "중고제품에 대한 설명글", createdAt: dateFormatter.date(from: "2024-09-25T12:34:56Z")!, isFavorite: false),
            Post(id:4, title:"자전거", category:1, price:3000, emdId:1, latitude: 37.5665, longitude: 126.9780, locationDetail: "00건물 2층", text: "중고제품에 대한 설명글", createdAt: dateFormatter.date(from: "2024-09-25T12:34:56Z")!, isFavorite: false)
        ]
        return posts
    }
    
    func postPost(post:Post) -> Void {
        // MySQL에 데이터 저장
        return
    }
}

