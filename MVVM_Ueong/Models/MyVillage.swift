//
//  MyVillage.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 10/2/24.
//

struct MyVillage: Decodable, Equatable, Identifiable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "emd_id"
        case name = "emd_name"
    }
    
    init(){
        self.id = 0
        self.name = "selectMockUp"
    }
}
