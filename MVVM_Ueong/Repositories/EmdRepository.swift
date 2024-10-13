//
//  EmdRepository.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 10/7/24.
//
class EmdRepository {
    func getMyVillages(username: String) async throws -> [Emd] {
        do {
            let myVillages: [Emd] = try await APICall.shared.get("emd/my-village", parameters: [("username", username)])
//            print("Successfully retrieved address: \(myVillages.count) myVillages for emdId: \(username).")
            return myVillages
        } catch {
            print("Error fetching address for emdId \(username): \(error)")
            throw error
        }
    }
    
    func getEmd(emdId: Int) async throws -> Emd {
        let emd: Emd = try await APICall.shared.get("emd", parameters: [("emdId", emdId)])
        return emd
    }
}

