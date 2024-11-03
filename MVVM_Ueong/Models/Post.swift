//
//  Product.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//
import Foundation
import MapKit

struct Post: Identifiable, Decodable {
  var id: Int
  var title: String
  var categoryId: Int
  var price: Double
  var writerUsername: String //작성자ID
  var emdId: Int
  var latitude: Double
  var longitude: Double
  var locationDetail: String
  var createAt: Date? // Optional Date
  var isFavorite: Bool
  var text: String
  var photos: [Photo]?
  var status: String
  var favoriteCount: Int
  var isActive: Bool
  var ar_model_id: Int?
  var ar_model_directory: String?
  
  enum CodingKeys: String, CodingKey {
    case id = "post_id"
    case title = "post_title"
    case categoryId = "category_id"
    case price
    case writerUsername = "writer_username"
    case emdId = "emd_id"
    case latitude = "desired_trading_location_latitude"
    case longitude = "desired_trading_location_longitude"
    case locationDetail = "desired_trading_location_detail"
    case rawCreateAt = "create_at" // JSON의 필드 이름
    case isFavorite = "is_favorite"
    case text
    case photos
    case status
    case favoriteCount = "favorite_count"
    case isActive = "is_active"
    case ar_model_id = "ar_model_id"
    case ar_model_directory = "ar_model_directory"
  }
  
    //디코더에서 쓰는 생성자
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    id = try container.decode(Int.self, forKey: .id)
    title = try container.decode(String.self, forKey: .title)
    categoryId = try container.decode(Int.self, forKey: .categoryId)
    price = try container.decode(Double.self, forKey: .price)
    writerUsername = try container.decode(String.self, forKey: .writerUsername)
    emdId = try container.decode(Int.self, forKey: .emdId)
    latitude = try container.decode(Double.self, forKey: .latitude)
    longitude = try container.decode(Double.self, forKey: .longitude)
    locationDetail = try container.decode(String.self, forKey: .locationDetail)
      // rawCreateAt을 Date로 변환
    let rawCreateAt = try container.decode(String.self, forKey: .rawCreateAt)
    createAt = DATETIMEToDate(TIMESTAMP: rawCreateAt)
    
    let favoriteValue = try container.decode(Int.self, forKey: .isFavorite)
    isFavorite = favoriteValue != 0 // 0이면 false, 그 외에는 true
    
    text = try container.decode(String.self, forKey: .text)
    status = try container.decode(String.self, forKey: .status)
    favoriteCount = try container.decode(Int.self, forKey: .favoriteCount)
    
    let isActiveInt = try container.decode(Int.self, forKey: .isActive)
    isActive = isActiveInt != 0
      
    ar_model_id = try container.decode(Int?.self, forKey: .ar_model_id)
    ar_model_directory = try container.decode(String?.self, forKey: .ar_model_directory)
  }
  
    // 목업데이터를 위한 생성자
  init() {
    self.id = 0
    self.title = "제목"
    self.categoryId = 1
    self.price = 3000.0
    self.writerUsername = "username1"
    self.emdId = 1
    self.latitude = 37
    self.longitude = 126
    self.locationDetail = "위치상세"
    self.createAt = Date()
    self.isFavorite = false
    self.text = "본문"
    self.photos = []
    self.status = "거래대기"
    self.favoriteCount = 1
    self.isActive = true
  }
  
}

struct NewPost :Encodable{
  var id: Int?
  var title: String
  var categoryId: Int
  var price: Double
  var writerUsername: String
  var emdId: Int
  var latitude: Double?
  var longitude: Double?
  var locationDetail: String
  var text: String
  
    // 새 포스트
  init(){
    self.id = nil
    self.title = ""
    self.categoryId = 1
    self.price = 0.0
    self.writerUsername = ""
    self.emdId = 1
    self.latitude = nil
    self.longitude = nil
    self.locationDetail = ""
    self.text = ""
  }
  
    //편집시 사용
  init(from post: Post) {
    self.id = post.id
    self.emdId = post.emdId
    self.writerUsername = post.writerUsername
    self.categoryId = post.categoryId
    self.price = post.price
    self.latitude = post.latitude
    self.longitude = post.longitude
    self.locationDetail = post.locationDetail
    self.title = post.title
    self.text = post.text
  }
  
  enum CodingKeys: String, CodingKey {
    case id = "post_id"
    case title
    case categoryId = "category_id"
    case price
    case writerUsername = "writer_username"
    case emdId = "emd_id"
    case latitude = "desired_trading_location_latitude"
    case longitude = "desired_trading_location_longitued"
    case locationDetail = "desired_trading_location_detail"
    case text
  }
  
  func toParams() -> [(String, Any)] {
    var params: [(String, Any)] = []
    
    if let id = self.id {
      params.append(("post_id", id))
    }
    params.append(("post_title", self.title))
    params.append(("category_id", self.categoryId))
    params.append(("price", Int(self.price)))
    params.append(("writer_username", self.writerUsername))
    params.append(("emd_id", self.emdId))
    
    if let latitude = self.latitude {
      params.append(("desired_trading_location_latitude", latitude))
    }
    if let longitude = self.longitude {
      params.append(("desired_trading_location_longitude", longitude))
    }
    
    params.append(("desired_trading_location_detail", self.locationDetail))
    params.append(("text", self.text))
    
    return params
  }
}
