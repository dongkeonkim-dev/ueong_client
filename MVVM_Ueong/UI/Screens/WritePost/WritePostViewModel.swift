//
//  WritePostViewModel.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//

import SwiftUI

extension WritePostView {
    class ViewModel: ObservableObject {
        @Published var post: PostPost
        
        init() {
            self.post = PostPost(title: "", category: 0, price: 0, emdId: 0, latitude: 0, longitude: 0, locationDetail: "", text: "")
        }
    }
}
