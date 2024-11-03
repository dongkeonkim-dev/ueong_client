//
//  PostRepository.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//
import Foundation


class PostRepository {
  
    // 비동기 함수로 나의 포스트 가져오기
  func getMyPosts() async throws -> [Post] {
    do {
      let posts: [Post] = try await APICall.shared.get("post/myPosts")
        //            print("Posts retrieved successfully: \(posts.count) my posts found.")
      return posts
    } catch {
      print("Error fetching my posts: \(error)")
      throw error
    }
  }
  
    // 비동기 함수로 검색된 포스트 가져오기
  func searchPosts(village: Int, searchTerm: String, arOnly: Bool, sortBy: String) async throws -> [Post] {
    do {
      let posts: [Post] = try await APICall.shared.get("post/search", queryParameters: ["emd_id":village, "search_term": searchTerm, "ar_only": arOnly, "sort_by": sortBy])
      return posts
    } catch {
      throw error
    }
  }
  
    // 비동기 함수로 특정 포스트 아이디로 포스트 가져오기
  func getPostById(postId: Int) async throws -> Post {
    do {
      let post: Post = try await APICall.shared.get("post", parameters: [("post_id",postId)])
      return post
    } catch {
      print("Error fetching a post: \(error)")
      throw error
    }
  }
  
    // 비동기 함수로 사용자 즐겨찾기 목록 가져오기
  func getFavoriteList() async throws -> [Post] {
    do {
      let posts: [Post] = try await APICall.shared.get("post/favorite")
      return posts
    } catch {
      print("Error fetching favorite posts: \(error)")
      throw error
    }
  }
  
  // 비동기 함수로 포스트 작성하기
  func uploadPost(post: NewPost, photoIds: [Int], arId: Int?) async throws -> Response {
      var parameters = post.toParams()
      parameters.append(("photo_ids", photoIds))
      if let arId = arId { // arId가 nil이 아닐 경우에만 추가
          parameters.append(("ar_model_id", arId))
      }
      let response: Response = try await APICall.shared
          .post("post", parameters: parameters)
      return response
  }
  
  func changePostStatus(postId: Int, status: String) async throws -> Response {
    let response : Response = try await APICall.shared
      .patch("post/change-status", parameters: [("post_id", postId), ("status", status)])
    return response
  }
    

  
  func editPost(post: NewPost, photoIds: [Int]) async throws -> Response {
    var parameters = post.toParams()
    parameters.append(("photo_ids", photoIds));
    let response : Response = try await APICall.shared
      .patch("post", parameters: parameters)
    return response
  }
  
  func inactivatePost(postId: Int) async throws -> Response {
    let response : Response = try await APICall.shared
      .patch("post/change-active", parameters: [("post_id", postId), ("is_active", 0)])
    return response
  }
}
