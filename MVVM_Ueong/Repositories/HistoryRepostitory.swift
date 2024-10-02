//
//  HistoryRepostitory.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 10/2/24.
//

class HistoryRepository {
    func getHistoryByUsername(username: String) async throws -> [History] {
        do {
            let history: [History] = try await APICall.shared.get("history/by-username", parameters: [username])
            print("Successfully retrieved address: \(history.count) history for emdId: \(username).")
            return history
        } catch {
            print("Error fetching address for emdId \(username): \(error)")
            throw error
        }
    }
    
}
