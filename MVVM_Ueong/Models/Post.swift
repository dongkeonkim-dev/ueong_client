//
//  Product.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//
import Foundation

struct Post: Identifiable, Decodable {
    let id: Int
    let title: String
    let category: Int
    let price: Double
    let emdId: Int
    let latitude: Double
    let longitude: Double
    let locationDetail: String
    let createAt: Date? // Optional Date
    var isFavorite: Bool
    let text: String
    var photos: [Photo]?
    let status: String

    enum CodingKeys: String, CodingKey {
        case id = "post_id"
        case title = "post_title"
        case category = "category_id"
        case price
        case emdId = "emd_id"
        case latitude = "desired_trading_location_latitude"
        case longitude = "desired_trading_location_longitude"
        case locationDetail = "desired_trading_location_detail"
        case rawCreateAt = "create_at" // JSON의 필드 이름
        case isFavorite = "is_favorite"
        case text
        case photos
        case status
    }
    
    //디코더에서 쓰는 생성자
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        category = try container.decode(Int.self, forKey: .category)
        price = try container.decode(Double.self, forKey: .price)
        emdId = try container.decode(Int.self, forKey: .emdId)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        locationDetail = try container.decode(String.self, forKey: .locationDetail)
        // rawCreateAt을 Date로 변환
        let rawCreateAt = try container.decode(String.self, forKey: .rawCreateAt)
        let dateFormatter = ISO8601DateFormatter()
        createAt = dateFormatter.date(from: rawCreateAt)
        
        let favoriteValue = try container.decode(Int.self, forKey: .isFavorite)
        isFavorite = favoriteValue != 0 // 0이면 false, 그 외에는 true
        
        text = try container.decode(String.self, forKey: .text)
        status = try container.decode(String.self, forKey: .status)
    }
    
    // 목업데이터를 위한 생성자
    init(id: Int, title: String, category: Int, price: Double, emdId: Int, latitude: Double, longitude: Double, locationDetail: String, createAt: Date?, isFavorite: Bool, text: String, photos: [Photo]? = nil, status: String) {
        self.id = id
        self.title = title
        self.category = category
        self.price = price
        self.emdId = emdId
        self.latitude = latitude
        self.longitude = longitude
        self.locationDetail = locationDetail
        self.createAt = createAt
        self.isFavorite = isFavorite
        self.text = text
        self.photos = photos
        self.status = status
    }
    
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
