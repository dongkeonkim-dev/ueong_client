//
//  History.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 10/2/24.
//


struct History: Decodable, Equatable, Identifiable {
    let id: Int
    let searchTerm: String
    
    enum CodingKeys: String, CodingKey {
        case id = "post_search_history_id"
        case searchTerm = "search_term"
    }
    
    init(){
        self.id = 0
        self.searchTerm = "searchTermMockUp"
    }
}
