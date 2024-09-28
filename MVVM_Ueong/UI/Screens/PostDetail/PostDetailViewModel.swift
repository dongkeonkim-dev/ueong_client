//
//  PostDetailViewModel.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/25/24.
//

import Foundation

import SwiftUI

extension PostDetail {
    class ViewModel: ObservableObject {
        @Published var post: Post
        
        init(post: Post) {
            self.post = post
        }
    }
}
