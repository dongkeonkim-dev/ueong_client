//
//  Response.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 10/4/24.
//

struct CreatedPhotosResponse: Decodable {
  let createdPhotos: [Photo]
}

enum Response: Decodable {
  case create(CreateResponse)
  case createMulti(CreateMultiResponse)
  case update(UpdateResponse)
  case message(MessageResponse)
  
  enum CodingKeys: String, CodingKey {
    case createId
    case createIds
    case affectedRows
    case message
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
      // `CreateResponse`인지 확인
    if let createId = try? container.decode(Int.self, forKey: .createId) {
      let response = CreateResponse(createId: createId)
      self = .create(response)
      return
    }
    
      // `CreateArrayResponse`인지 확인
    if let createIds = try? container.decode([Int].self, forKey: .createIds) {
      let response = CreateMultiResponse(createIds: createIds)
      self = .createMulti(response)
      return
    }
    
      // `UpdateResponse`인지 확인
    if let affectedRows = try? container.decode(Int.self, forKey: .affectedRows) {
      let response = UpdateResponse(affectedRows: affectedRows)
      self = .update(response)
      return
    }
    
    if let message = try? container.decode(String.self, forKey: .message) {
      let response = MessageResponse(message: message)
      self = .message(response)
      return
    }
    
    throw DecodingError.typeMismatch(Response.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unable to decode Response"))
  }
}

struct CreateResponse {
  let createId: Int
}

struct CreateMultiResponse {
  let createIds: [Int]
}

struct UpdateResponse {
  let affectedRows: Int
}

struct MessageResponse {
  let message: String
}
