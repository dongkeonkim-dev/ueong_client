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
    func addFavorite(postId: Int) async throws -> Response {
      let response: Response = try await apiCall.post("favorite", parameters: [("post_id", postId)])
      return response
    }
    
    // 즐겨찾기 삭제
    func deleteFavorite(postId: Int) async throws -> Response {
      let response: Response = try await apiCall.delete("favorite", queryParameters: ["post_id":postId])
      return response
    }
}

