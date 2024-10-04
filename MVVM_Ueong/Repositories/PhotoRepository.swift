//
//  PhotoRepository.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/28/24.
//

import Foundation

class PhotoRepository {
    // 비동기 함수로 특정 포스트의 사진 목록을 가져오기
    func getPhotosForPost(postId: Int) async throws -> [Photo] {
        do {
            let photos: [Photo] = try await APICall.shared.get("photo", parameters: [("postId",postId)])
            print("Successfully retrieved \(photos.count) photos for post ID \(postId).")
            return photos
        } catch {
            print("Error fetching photos for post ID \(postId): \(error)")
            throw error
        }
    }
}

