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
            Text(viewModel.PostDetail.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("\(viewModel.PostDetail.price, specifier: "%.2f")원")
                .font(.title)
                .foregroundColor(.secondary)
            Text(viewModel.PostDetail.description)
                .font(.body)
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

#Preview {
    PostDetail(viewModel: PostDetail.ViewModel())
}
