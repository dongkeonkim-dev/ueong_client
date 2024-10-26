//
//  Product.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//
import Foundation

struct Photo: Identifiable, Decodable {
  var id: Int
  var postId: Int?
  var url: String
  var uploadAt: Date?
  
  enum CodingKeys: String, CodingKey {
    case id = "photo_id"
    case postId = "post_id"
    case url = "photo_path"
    case rawUploadAt = "upload_at" // JSON의 필드 이름
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    id = try container.decode(Int.self, forKey: .id)
    postId = try container.decode(Int?.self, forKey: .postId)
    url = try container.decode(String.self, forKey: .url)
    
    let rawUploadAt = try container.decode(String.self, forKey: .rawUploadAt)
    uploadAt = DATETIMEToDate(TIMESTAMP: rawUploadAt)
  }
}


