//
//  PhotoRepository.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/28/24.
//

import Foundation

class PhotoRepository {
    func getPhotosForPost(postId: Int, completion: @escaping ([Photo]) -> Void) {
        // API 호출을 통해 사진을 가져오는 로직
        APICall.shared.get("photo/by-post-id", parameters: ["postId": postId]) { (result: Result<[Photo], Error>) in
            switch result {
            case .success(let photos):
                print("Successfully retrieved \(photos.count) photos for post ID \(postId).")
                completion(photos)
            case .failure(let error):
                print("Error fetching photos for post ID \(postId): \(error)")
                completion([]) // 실패 시 빈 배열 반환
            }
        }
    }
}

