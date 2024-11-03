//
//  PhotoRepository.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/28/24.
//

import Foundation

class PhotoRepository {
    // 비동기 함수로 특정 포스트의 사진 목록을 가져오기
  func getPhotosByPostId(postId: Int) async throws -> [Photo] {
    do {
      let photos: [Photo] = try await APICall.shared.get("photo", parameters: [("postId",postId)])
      return photos
    } catch {
      print("Error fetching photos for post ID \(postId): \(error)")
      throw error
    }
  }
  
  func uploadPhotos(images: [Data] = []) async throws -> [Photo] {
      // 이미지 데이터를 File 구조체 배열로 변환
    print("images.length: ",images.count)
    let imagesToUpload = images.map { imageData in
      File(
        data: imageData,
        fieldName: "image",
        fileName: "image.jpg" + UUID().uuidString,
        mimeType: "image/jpeg"
      )
    }
    let response: CreatedPhotosResponse = try await APICall.shared.post("photo", files: imagesToUpload)
    return response.createdPhotos
  }
  
  func deletePhoto(photoId: Int) async throws {
    try await APICall.shared
      .delete("photo", queryParameters: ["photo_id": photoId])
  }
}

