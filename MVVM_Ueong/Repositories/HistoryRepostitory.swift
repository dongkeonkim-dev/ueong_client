//
//  HistoryRepostitory.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 10/2/24.
//

class HistoryRepository {
    func getHistory(username: String) async throws -> [History] {
        do {
            let history: [History] = try await APICall.shared.get("history", parameters: [("username",username)])
            print("Successfully retrieved address: \(history.count) history for emdId: \(username).")
            return history
        } catch {
            print("Error fetching address for emdId \(username): \(error)")
            throw error
        }
    }
    
    func deleteHistory(username: String, searchTerm: String) async {
        do {
            try await APICall.shared.delete("history", queryParameters: ["username": username, "searchTerm": searchTerm])
        } catch {
            print("Error deleting history: \(error)")
        }
    }
    
}
