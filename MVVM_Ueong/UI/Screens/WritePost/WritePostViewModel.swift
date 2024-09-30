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
        @Published var post: PostPost
        @Published var isPosting: Bool = false
        @Published var postSuccess: Bool? = nil
        @Published var errorMessage: String? = nil

        init() {
            self.post = PostPost(title: "", category: 1, price: 0, writerUsername:"username1", emdId: 1, latitude: 37, longitude: 136, locationDetail: "", text: "")
        }

        func postPost() {
            guard !isPosting else { return } // 중복 요청 방지
            isPosting = true
            postRepository.postPost(post: post) { [weak self] result in
                DispatchQueue.main.async {
                    self?.isPosting = false
                    switch result {
                    case .success:
                        self?.postSuccess = true
                        print("Post successfully uploaded.")
                    case .failure(let error):
                        self?.postSuccess = false
                        self?.errorMessage = error.localizedDescription
                        print("Error uploading post: \(error.localizedDescription)")
                    }
                }
            }
        }

    }
}
