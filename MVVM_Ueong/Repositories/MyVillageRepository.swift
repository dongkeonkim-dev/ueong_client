//
//  MyVillageRepository.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 10/18/24.
//
class MyVillageRepository {
    func getMyVillages() async throws -> [Emd] {
        do {
            let myVillages: [Emd] = try await APICall.shared.get("my-village")
            return myVillages
        } catch {
            print("Error fetching address for emdId : \(error)")
            throw error
        }
    }
    
    func addMyVillage(emdId: Int) async throws -> Response {
      let response: Response = try await APICall.shared.post("my-village/add", parameters:[("emd_id", emdId)])
        return response
    }
}

