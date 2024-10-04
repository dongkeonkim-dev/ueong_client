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
//    func postPost(post: PostPost, images: [Data]) async throws {
//        let imagesToUpload = images.map { (data: $0, fileName: post.title+".jpg", mimeType: "image/jpeg") }
//        let parameters = 
//        try await APICall.shared.postMultipart(endpoint: "post", parameters: post, files: imagesToUpload)
//    }
//    
//    func post<U: Decodable>(_ endpoint: String,
//                  parameters: [(key: String, value: String)] = [],
//                            files: [(data: Data, fileName: String, mimeType: String)] = []) async throws -> U? {
//        guard let result : U = try await request(endpoint: endpoint, method: .post, parameters: parameters, files: files) else {
//            throw URLError(.badServerResponse)
//        }
//        return result
//    }
}
