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
        _ = try await apiCall.post("favorite", parameters: [("postId", postId), ("username", username)])
    }
    
    // 즐겨찾기 삭제
    func deleteFavorite(postId: Int, username: String) async throws {
        _ = try await apiCall.delete("favorite", queryParameters: ["postId":postId, "username":username])
    }
}

