//
//  Product.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//
import Foundation

struct Photo: Identifiable, Decodable {
    let id: Int
    let postId: Int
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id = "photo_id"
        case postId = "post_id"
        case url = "photo_directory"
    }
}


