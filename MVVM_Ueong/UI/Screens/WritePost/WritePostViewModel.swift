//
//  WritePostViewModel.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//

import SwiftUI

extension WritePost {
    class ViewModel: ObservableObject {
        let postRepository = PostRepository()
        var username: String
        @Published var post: NewPost
        @Published var isPosting: Bool = false

        init() {
            self.username = "username1"
            self.post = NewPost()
        }
        
        func fetchPage(){
            self.username = "username1"
            self.post = NewPost()
            self.post.writerUsername = username
        }
        
        func uploadPost() async {
            Task { @MainActor in
                guard !isPosting else { return } // 중복 요청 방지
                isPosting = true
                do{
                    let response : Response =  try await postRepository.uploadPost(post: post, images:[])
                    print(response.message)
                    self.isPosting = false
                }catch{
                    print("failure uploadPost")
                    self.isPosting = false
                }
            }
        }
    }
}

