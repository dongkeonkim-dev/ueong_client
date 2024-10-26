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
        //            print("Posts retrieved successfully: \(posts.count) my posts found.")
      return posts
    } catch {
      print("Error fetching my posts: \(error)")
      throw error
    }
  }
  
    // 비동기 함수로 검색된 포스트 가져오기
  func searchPosts(username: String, village: Int, searchTerm: String, sortBy: String) async throws -> [Post] {
    do {
      let posts: [Post] = try await APICall.shared.get("post/search", parameters: [("username",username)], queryParameters: ["emd_id":village, "search_term": searchTerm, "sort_by": sortBy])
      return posts
    } catch {
      throw error
    }
  }
  
    // 비동기 함수로 특정 포스트 아이디로 포스트 가져오기
  func getPostById(username: String, postId: Int) async throws -> Post {
    do {
      let post: Post = try await APICall.shared.get("post", parameters: [("post_id",postId),("username",username)])
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
      return posts
    } catch {
      print("Error fetching favorite posts: \(error)")
      throw error
    }
  }
  
    // 비동기 함수로 포스트 작성하기
  func uploadPost(post: NewPost, photoIds: [Int]) async throws -> Response {
    var parameters = post.toParams()
    parameters.append(("photo_ids", photoIds));
    let response : Response = try await APICall.shared
      .post("post", parameters: parameters)
    print("PostRepository: 포스트 업로드 성공")
    return response
  }
  
  func editPost(post: NewPost, photoIds: [Int]) async throws -> Response {
    var parameters = post.toParams()
    parameters.append(("photo_ids", photoIds));
    let response : Response = try await APICall.shared
      .patch("post", parameters: parameters)
    print("PostRepository: 포스트 편집 성공")
    return response
  }
  
  func inactivatePost(postId: Int) async throws -> Response {
    let response : Response = try await APICall.shared
      .patch("post/change-active", parameters: [("post_id", postId), ("is_active", 0)])
    return response
  }
}
