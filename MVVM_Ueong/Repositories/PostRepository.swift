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
            let posts: [Post] = try await APICall.shared.get("post/myPosts/by-username", parameters: [username])
            print("Posts retrieved successfully: \(posts.count) my posts found.")
            return posts
        } catch {
            print("Error fetching my posts: \(error)")
            throw error
        }
    }
    
    // 비동기 함수로 검색된 포스트 가져오기
    func searchPosts(username: String, searchTerm: String) async throws -> [Post] {
        do {
            let posts: [Post] = try await APICall.shared.get("post/search", parameters: [username], queryParameters: ["searchTerm": searchTerm])
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
            let post: Post = try await APICall.shared.get("post/by-id", parameters: [username,postId])
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
            let posts: [Post] = try await APICall.shared.get("post/favorite/by-username", parameters: [username])
            print("Posts retrieved successfully: \(posts.count) favorite posts found.")
            return posts
        } catch {
            print("Error fetching favorite posts: \(error)")
            throw error
        }
    }
    
    // 비동기 함수로 포스트 작성하기
    func postPost(post: PostPost) async throws {
        do {
            try await APICall.shared.post("post/postPost", body: post)
            print("Post created successfully.")
        } catch {
            print("Error creating post: \(error)")
            throw error
        }
    }
}
