//
//  MyVillageRepository.swift
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

class MyVillageRepository {
    func getMyVillagesByUsername(username: String) async throws -> [MyVillage] {
        do {
            let myVillages: [MyVillage] = try await APICall.shared.get("my-village/by-username", parameters: [username])
            print("Successfully retrieved address: \(myVillages.count) myVillages for emdId: \(username).")
            return myVillages
        } catch {
            print("Error fetching address for emdId \(username): \(error)")
            throw error
        }
    }
}
