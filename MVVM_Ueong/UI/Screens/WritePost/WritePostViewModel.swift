import SwiftUI
import CoreLocation

protocol WritePostViewModelDelegate: AnyObject {
    func didUpdateLocation(latitude: Double, longitude: Double, locationDetail: String)
}

extension WritePost {
    class ViewModel: ObservableObject, WritePostViewModelDelegate {
        
        let postRepository = PostRepository()
        let emdRepository = EmdRepository()
        
        @Published var post = NewPost()
        @Published var isPosting: Bool = false
        @Published var selectedImages: [UIImage] = [] // 선택된 이미지 배열
        @Published var isLocationSelected: Bool = false // NavigationLink의 대체 역할을 할 상태 변수
        

        init(emdId: Int){
            fetchPage(emdId: emdId)
        }
        
        func fetchPage(emdId: Int) {
            Task { @MainActor in
                self.post = NewPost()
                print(post)
                self.post.emdId = emdId
                print(post)
                self.selectedImages.removeAll()
                self.post.writerUsername = username
                self.post.locationDetail = ""
            }
        }
        
        func uploadPost() async -> Response? {
            guard !isPosting else {
                print("Already posting, request ignored.")
                return nil // 중복 요청 방지
            }
            await MainActor.run {
                self.isPosting = false
            }
            do {
                // 이미지 데이터를 JPEG로 압축
                let imageData = selectedImages.compactMap { $0.jpegData(compressionQuality: 0.8) }
                
                // 비동기 호출로 게시물 업로드
                let response: Response = try await postRepository.uploadPost(post: post, images: imageData, models: [])
                
                print("Success: \(response.message)") // 성공 메시지 출력
                await MainActor.run {
                    self.isPosting = false
                }
                return response // 응답 반환
            } catch {
                print("Failure uploading post: \(error.localizedDescription)") // 에러 출력
                await MainActor.run {
                    self.isPosting = false
                }
                return nil // 실패 시 nil 반환
            }
        }
        
        func didUpdateLocation(latitude: Double, longitude: Double, locationDetail: String){
            Task{ @MainActor in
                self.post.latitude = latitude
                self.post.longitude = longitude
                self.post.locationDetail = locationDetail
                print("end save: ",post)
            }
        }
    }
}
