//
//  PostDetail.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/25/24.
//

import SwiftUI

struct PostDetail: View {
    @ObservedObject var viewModel: PostDetail.ViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let postDetail = viewModel.PostDetail { // 옵셔널 바인딩
                Text(postDetail.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("\(postDetail.price, specifier: "%.2f")원")
                    .font(.title)
                    .foregroundColor(.secondary)
                Text(postDetail.text)
                    .font(.body)
            } else {
                Text("포스트를 찾을 수 없습니다.") // nil일 경우의 대체 텍스트
                    .font(.body)
                    .foregroundColor(.red)
            }
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}

