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
    let arRepository = ArRepository() // AR 파일 관리를 위한 ARRepository 추가

    
    @Published var post = NewPost()
    @Published var isPosting: Bool = false
    @Published var selectedPhotos: [Photo] = [] // 선택된 이미지 배열
    @Published var isLocationSelected: Bool = false // NavigationLink의 대체 역할을 할 상태 변수
    @Published var state: createOrEdit = .create
    var addPostRow: (Post) -> Void
    @Published var selectedARFile: AR?
    var refreshPostsList: () -> Void = {}
    
    init(
      emdId: Int?,
      postId: Int?,
      addPostRow: @escaping (Post) -> Void,
      refreshPostsList: @escaping () -> Void
    ){
      self.addPostRow = addPostRow
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
            .getPostById(postId: postId)
          self.post = NewPost(from: existPost)
            
            
          //사진 정보 불러오기
          await fetchPhotos(postId: postId, photoIds: nil)
            
          //AR파일 정보 불러오기
          await fetchARFile(postId: postId)
            
            
        }else if let emdId = emdId{
        // 새로운 포스트 생성
          state = .create
          print("create")
          //post 정보 초기화
          self.post.emdId = emdId
          self.post.writerUsername = UserDefaultsManager.shared.getUsername() ?? ""
          self.post.locationDetail = ""
          self.selectedPhotos = []
          self.selectedARFile = nil // 새 포스트 시 AR 파일 초기화

        }
      }
    }
      
    // fetchPhotos (사진 가져오기)
    func fetchPhotos(postId: Int?, photoIds: [Int]?) async {
      guard let postId = postId else{return}
      Task { @MainActor in
        let photos = try await photoRepository.getPhotosByPostId(postId: postId)
        selectedPhotos = photos
        
      }
    }
    
    
      
    // fetchARFile (AR파일 가져오기)
    func fetchARFile(postId: Int?) async {
      guard let postId = postId else { return }
      Task { @MainActor in
        let ARFile = try await arRepository.getARFileByPostId(postId: postId)
        selectedARFile = ARFile
          
      }
    }
      
    // uploadPost (포스트 생성)
    @MainActor   
    func uploadPost() async -> Response? {
      guard !isPosting else { return nil }
      do { // 비동기 호출로 게시물 업로드
        if state == .create{
          //생성
          let photoIds = self.selectedPhotos.map{$0.id}
          let arId = self.selectedARFile?.id
          let response = try await postRepository
            .uploadPost(post: post, photoIds: photoIds, arId: arId)
          self.isPosting = false
          switch response {
            case .create(let createResponse):
              let createId = createResponse.createId
              let uploadedPost = try await postRepository.getPostById(postId: createId)
              self.addPostRow(uploadedPost)
              return response
            default:
                // Handle unexpected response types
              print("Unexpected response type: \(response)")
              return nil
          }
        } else {
          //편집
          let photoIds = self.selectedPhotos.map{$0.id}
          let response: Response = try await postRepository
            .editPost(post: post, photoIds: photoIds)
          await MainActor.run {
            self.isPosting = false
            self.refreshPostsList()
          }
          return response // 응답 반환
        }
      } catch {
        await MainActor.run { self.isPosting = false }
        return nil // 실패 시 nil 반환
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
      
      // AR 파일 업로드 함수
      func uploadARFile(_ url: URL) async -> AR? {
          do {
              // AR 파일 데이터를 읽기
              let data = try Data(contentsOf: url)

              // 업로드를 위한 Repository 호출
              let arFile: AR = try await arRepository.uploadARFile(data: data)
              return arFile
          } catch {
              print("AR 파일 업로드 중 오류 발생: \(error.localizedDescription)")
              return nil // 오류 발생 시 nil 반환
          }
      }

    
    func addSelectedImages(_ images: [UIImage]) async {
      let datas = images.compactMap { $0.jpegData(compressionQuality: 0.8) }
      Task {@MainActor in
        selectedPhotos = await uploadImages(imageDatas: datas) ?? []
      }
    }
      
    
      func addSelectedARFile(_ url: URL) async {
          let validFileTypes = ["usdz", "reality"]
              guard validFileTypes.contains(url.pathExtension) else {
                  print("잘못된 파일 타입")
                  return
              }
          
        Task {@MainActor in
            selectedARFile = await uploadARFile(url)
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
