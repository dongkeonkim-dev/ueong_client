import SwiftUI

extension WritePost {
    class ViewModel: ObservableObject {
        let postRepository = PostRepository()
        var username: String
        @Published var post = NewPost()
        @Published var isPosting: Bool = false
        @Published var selectedImages: [UIImage] = [] // 선택된 이미지 배열

        init(village: MyVillage) {
            self.username = "username1"
        }
        
        func fetchPage() async{
            Task { @MainActor in
                self.post = NewPost()
                self.selectedImages.removeAll()
                self.post.writerUsername = username
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
    }
}
