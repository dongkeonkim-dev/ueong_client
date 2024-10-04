//
//  WritePostViewModel.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//

import SwiftUI

extension WritePostView {
    class ViewModel: ObservableObject {
        let postRepository = PostRepository()
        var username: String
        @Published var post: PostPost
        @Published var isPosting: Bool = false

        init() {
            self.username = "username1"
            self.post = PostPost()
        }
        
        func fetchPage(){
            self.username = "username1"
            self.post = PostPost()
            self.post.writerUsername = username
        }
        
        func postPost() {
            Task { @MainActor in
                guard !isPosting else { return } // 중복 요청 방지
                isPosting = true
                do{
                    //try await postRepository.postPost(post: post, images:[])
                    print("success postpost")
                    self.isPosting = false
                }catch{
                    print("failure postpost")
                    self.isPosting = false
                }
                
            }
        }
    }
}

