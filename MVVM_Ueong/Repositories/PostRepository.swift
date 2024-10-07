//
//  PostRepository.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//
import Foundation


class PostRepository {
    
    // 비동기 함수로 나의 포스트 가져오기
    func getMyPosts(username: String) async throws -> [Post] {
        do {
            let posts: [Post] = try await APICall.shared.get("post/myPosts", parameters: [("username",username)])
            print("Posts retrieved successfully: \(posts.count) my posts found.")
            return posts
        } catch {
            print("Error fetching my posts: \(error)")
            throw error
        }
    }
    
    // 비동기 함수로 검색된 포스트 가져오기
    func searchPosts(username: String, village: Int, searchTerm: String, sortBy: String) async throws -> [Post] {
        do {
            let posts: [Post] = try await APICall.shared.get("post/search", parameters: [("username",username)], queryParameters: ["village":village, "searchTerm": searchTerm, "sortBy": sortBy])
            print("Posts retrieved successfully: \(posts.count) posts found.")
            return posts
        } catch {
            print("Error fetching posts: \(error)")
            throw error
        }
    }
    
    // 비동기 함수로 특정 포스트 아이디로 포스트 가져오기
    func getPostById(username: String, postId: Int) async throws -> Post {
        do {
            let post: Post = try await APICall.shared.get("post/", parameters: [("postId",postId),("username",username)])
            print("Post retrieved successfully: post found.")
            return post
        } catch {
            print("Error fetching a post: \(error)")
            throw error
        }
    }
    
    // 비동기 함수로 사용자 즐겨찾기 목록 가져오기
    func getFavoriteList(username: String) async throws -> [Post] {
        do {
            let posts: [Post] = try await APICall.shared.get("post/favorite", parameters: [("username",username)])
            print("Posts retrieved successfully: \(posts.count) favorite posts found.")
            return posts
        } catch {
            print("Error fetching favorite posts: \(error)")
            throw error
        }
    }
    
    // 비동기 함수로 포스트 작성하기
    func uploadPost(post: NewPost, images: [Data] = [], models: [Data] = []) async throws -> Response {
        // 이미지 데이터를 File 구조체 배열로 변환
        let imagesToUpload = images.map { imageData in
            File(data: imageData, fieldName: "image", fileName: "\(post.title).jpg", mimeType: "image/jpeg")
        }
        
        // 모델 파일을 File 구조체 배열로 변환
        let modelsToUpload = models.map { modelData in
            File(data: modelData, fieldName: "model", fileName: "\(post.title).3d", mimeType: "model/vnd.collada+xml") // MIME 타입은 필요에 따라 조정
        }
        
        // NewPost를 파라미터 형식으로 변환
        let parameters = post.toParams()
        
        // API 호출
        let response = try await APICall.shared.post("post", parameters: parameters, files: imagesToUpload + modelsToUpload)
        return response
    }
}
