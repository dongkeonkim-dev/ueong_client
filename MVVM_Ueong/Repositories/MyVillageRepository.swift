//
//  MyVillageRepository.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 10/18/24.
//
class MyVillageRepository {
    func getMyVillages(username: String) async throws -> [Emd] {
        do {
            let myVillages: [Emd] = try await APICall.shared.get("my-village", parameters: [("username", username)])
//            print("Successfully retrieved address: \(myVillages.count) myVillages for emdId: \(username).")
            return myVillages
        } catch {
            print("Error fetching address for emdId \(username): \(error)")
            throw error
        }
    }
    
    func addMyVillage(emdId: Int) async throws -> Response {
      let response: Response = try await APICall.shared.post("my-village/add", parameters: [("username",username), ("emd_id", emdId)]) // /Users/gimdong-geon/Documents/ueong_client/MVVM_Ueong/Repositories/MyVillageRepository.swift:20:49 Generic parameter 'T' could not be inferred

        return response
    }
}

