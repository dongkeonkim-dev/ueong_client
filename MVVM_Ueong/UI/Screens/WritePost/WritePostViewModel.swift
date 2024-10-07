import SwiftUI
import CoreLocation

protocol WritePostViewModelDelegate: AnyObject {
    func didUpdateLocation(latitude: Double, longitude: Double, locationDetail: String)
}

extension WritePost {
    class ViewModel: ObservableObject, WritePostViewModelDelegate {
        
        let postRepository = PostRepository()
        let emdRepository = EmdRepository()
        var username: String
        @Published var post = NewPost()
        @Published var isPosting: Bool = false
        @Published var selectedImages: [UIImage] = [] // 선택된 이미지 배열
        @Published var isLocationSelected: Bool = false // NavigationLink의 대체 역할을 할 상태 변수
        

        init(emdId: Int){
            self.username = "username1"
            self.post.emdId = emdId
        }
        
        func fetchPage() {
            Task { @MainActor in
                self.post = NewPost()
                self.selectedImages.removeAll()
                self.post.writerUsername = username
                self.post.locationDetail = ""
            }
        }
        
        func uploadPost() async {
            Task { @MainActor in
                guard !isPosting else { return } // 중복 요청 방지
                isPosting = true
                do {
                    let imageData = selectedImages.compactMap { $0.jpegData(compressionQuality: 0.8) }
                    let response: Response = try await postRepository.uploadPost(post: post, images: imageData, models: [])
                    print(response.message)
                    self.isPosting = false
                } catch {
                    print("Failure uploading post")
                    self.isPosting = false
                }
            }
        }
        
        func didUpdateLocation(latitude: Double, longitude: Double, locationDetail: String){
            Task{ @MainActor in
                self.post.latitude = latitude
                self.post.longitude = longitude
                self.post.locationDetail = locationDetail
                print(post)
            }
        }
    }
}
