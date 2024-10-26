import SwiftUI
import CoreLocation

protocol WritePostViewModelDelegate: AnyObject {
  func didUpdateLocation(latitude: Double, longitude: Double, locationDetail: String)
}

enum createOrEdit {
  case edit
  case create
}

extension WritePost {
  class ViewModel: ObservableObject, WritePostViewModelDelegate {
    
    let postRepository = PostRepository()
    let photoRepository = PhotoRepository()
    
    @Published var post = NewPost()
    @Published var isPosting: Bool = false
    @Published var selectedPhotos: [Photo] = [] // 선택된 이미지 배열
    @Published var isLocationSelected: Bool = false // NavigationLink의 대체 역할을 할 상태 변수
    @Published var state: createOrEdit = .create
    var refreshPostsList: () -> Void
    
    init(
      emdId: Int?,
      postId: Int?,
      refreshPostsList: @escaping () -> Void
    ){
      self.refreshPostsList = refreshPostsList
      fetchPage(emdId: emdId, postId: postId)
    }
    
    func fetchPage(emdId: Int?, postId: Int?) {
      Task { @MainActor in
        
        if let postId = postId{
        // 기존 포스트 편집
          state = .edit
          print("edit")
          //post 정보 초기화
          let existPost: Post = try await postRepository
            .getPostById(username: username, postId: postId)
          self.post = NewPost(from: existPost)
          //사진 정보 불러오기
          await fetchPhotos(postId: postId, photoIds: nil)
        }else if let emdId = emdId{
        // 새로운 포스트 생성
          state = .create
          print("create")
          //post 정보 초기화
          self.post.emdId = emdId
          self.post.writerUsername = username
          self.post.locationDetail = ""
          self.selectedPhotos = []
        }
      }
    }
    
    func fetchPhotos(postId: Int?, photoIds: [Int]?) async {
      guard let postId = postId else{return}
      Task { @MainActor in
        let photos = try await photoRepository.getPhotosByPostId(postId: postId)
        selectedPhotos = photos
        
      }
    }
    
    @MainActor
    func uploadPost() async -> Response? {
      guard !isPosting else { return nil }
      isPosting = true
      defer {
        isPosting = false
      }
      do {
        let photoIds = self.selectedPhotos.map { $0.id }
        let response: Response
        if state == .create {
          response = try await postRepository.uploadPost(post: post, photoIds: photoIds)
        } else {
          response = try await postRepository.editPost(post: post, photoIds: photoIds)
        }
        //await self.refreshPostsList()
        return response
      } catch {
        print("Error uploading post: \(error.localizedDescription)")
        return nil
      }
    }
    
    func deleteImage(photoId: Int) async {
      await MainActor.run {
        if let index = selectedPhotos.firstIndex(where: { $0.id == photoId }) {
          selectedPhotos.remove(at: index)
        }
      }
    }
    
    
    func uploadImages(imageDatas: [Data]) async -> [Photo]? {
      do {
        let photos: [Photo] = try await photoRepository.uploadPhotos(images: imageDatas)
        print(photos)
        return photos
      } catch {
        print("Error uploading images: \(error.localizedDescription)")
        return nil // 오류 발생 시 nil 반환
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
    
    func addSelectedImages(_ images: [UIImage]) async {
      let datas = images.compactMap { $0.jpegData(compressionQuality: 0.8) }
      Task {@MainActor in
        let uploadPhotos = await uploadImages(imageDatas: datas) ?? []
        selectedPhotos.append(contentsOf: uploadPhotos)
      }
    }
  }
}
