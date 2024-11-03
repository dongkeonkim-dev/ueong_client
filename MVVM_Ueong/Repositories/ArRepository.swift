//
//  ArRepository.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 10/28/24.
//

import Foundation

class ArRepository {
    
    func getARFileByPostId(postId: Int) async throws -> AR {
        do {
          let ARFile: AR = try await APICall.shared.get("ar", parameters: [("postId",postId)])
          return ARFile
        } catch {
          print("Error fetching photos for post ID \(postId): \(error)")
          throw error
        }
      }
    
    
    func uploadARFile(data: Data) async throws -> AR {
        // AR 파일 데이터를 File 구조체로 변환
        let arFileToUpload = File(
            data: data,
            fieldName: "model",
            fileName: "model.usdz", // 파일 이름을 적절하게 설정
            mimeType: "model/usdz"   // MIME 타입을 적절하게 설정
        )
        
        // API 호출을 통해 AR 파일 업로드
        let response: CreatedARResponse = try await APICall.shared.post("ar", files: [arFileToUpload])
        
        // 업로드된 AR 파일 반환
        return response.createdAR
    }
    
    func deleteARFile(arId: Int) async throws {
      try await APICall.shared
        .delete("ar", queryParameters: ["ar_id": arId])
    }

}
