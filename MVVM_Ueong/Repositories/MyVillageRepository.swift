//
//  MyVillageRepository.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 10/2/24.
//


class MyVillageRepository {
    func getMyVillages(username: String) async throws -> [MyVillage] {
        do {
            let myVillages: [MyVillage] = try await APICall.shared.get("my-village", parameters: [("username", username)])
            print("Successfully retrieved address: \(myVillages.count) myVillages for emdId: \(username).")
            return myVillages
        } catch {
            print("Error fetching address for emdId \(username): \(error)")
            throw error
        }
    }
}
