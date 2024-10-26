//
//  FavoriteRepository.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 10/6/24.
//
import Foundation

class FavoriteRepository {
    private let apiCall = APICall.shared

    // 즐겨찾기 추가
    func addFavorite(postId: Int, username: String) async throws {
      let response: Response = try await apiCall.post("favorite", parameters: [("post_id", postId), ("username", username)]) ///Users/gimdong-geon/Documents/ueong_client/MVVM_Ueong/Repositories/FavoriteRepository.swift:14:29 Generic parameter 'T' could not be inferred

    }
    
    // 즐겨찾기 삭제
    func deleteFavorite(postId: Int, username: String) async throws {
      let response: VoidResult = try await apiCall.delete("favorite", queryParameters: ["post_id":postId, "username":username])
    }
}

