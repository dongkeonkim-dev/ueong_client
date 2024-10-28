import Foundation

struct CreateResponse: Decodable {
  let createId: Int
}

struct CreateMultiResponse: Decodable {
  let createIds: [Int]
}

struct UpdateResponse: Decodable {
  let affectedRows: Int
}

struct MessageResponse: Decodable {
  let message: String
}

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
    
    if let createId = try? container.decode(Int.self, forKey: .createId) {
      let response = CreateResponse(createId: createId)
      self = .create(response)
      return
    }
    
    if let createIds = try? container.decode([Int].self, forKey: .createIds) {
      let response = CreateMultiResponse(createIds: createIds)
      self = .createMulti(response)
      return
    }
    
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
