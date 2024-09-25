//
//  Product.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//
import Foundation

struct Post: Identifiable {
    let id: Int
    let title: String
//    let category: Int
    let price: Double
//    let emdId: Int
//    let latitude: Double
//    let longitude: Double
//    let locationDetail: String
//    let createdAt: Date
    let isFavorite: Bool
    let text: String
}

struct PostPost {
    var title: String
    var category: Int
    var price: Double
    var emdId: Int
    var latitude: Double
    var longitude: Double
    var locationDetail: String
    var text: String
}
