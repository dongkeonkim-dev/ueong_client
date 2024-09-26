//
//  UserRepository.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//

import Foundation

class ImageRepository {
    func getImageById() -> PostImage {
        // MySQL에서 데이터 받아오는 로직
        
        let image = PostImage(id: 1, postId: 1, image: "cat1")
        
        return image
    }
}

