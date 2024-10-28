//
//  Emd.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 10/7/24.
//
struct Emd: Decodable, Equatable, Identifiable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "emd_id"
        case name = "emd_name"
        case latitude = "emd_latitude"
        case longitude = "emd_longitude"
    }
    
  init(for usage: Usage){
    switch usage {
        
      case .mockedUp:
        self.id = 1
        self.name = "selectMockUp"
        self.latitude = 37.5665
        self.longitude = 126.978
        
      case .noVillage:
        self.id = 0
        self.name = "내 동네"
        self.latitude = 37.5665
        self.longitude = 126.978
    }
  }
  
  enum Usage{
    case mockedUp
    case noVillage
  }
}
