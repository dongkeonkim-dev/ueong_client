//
//  SearchPostViewModel.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 10/2/24.
//

import SwiftUI

extension SearchPost {
    class ViewModel: ObservableObject {
        @Published var histories : [History] = [History()]
        let username: String
        let postRepository = PostRepository()
        let historyRepository = HistoryRepository()
        @Published var searchTerm: String = ""

        init() {
            self.username = "username1"
        }

        func fetchSearchHistory(){
            Task{ @MainActor in
                self.histories = try await historyRepository.getHistory()
            }
        }
        
        func deleteHistoryBySearchTerm(username:String, searchTerm: String) {
            Task { @MainActor in
                await historyRepository.deleteHistory(searchTerm: searchTerm)
                fetchSearchHistory()
            }
        }

    }
}
