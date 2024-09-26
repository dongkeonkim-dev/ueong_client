//
//  PostRow.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/25/24.
//

import SwiftUI

struct PostRow: View {
    var post: Post
    var image: PostImage
    
    var body: some View {
        HStack {
            productImage
            productDescription
        }
        .frame(height: 150)
        .background(Color.primary.colorInvert())
        .cornerRadius(6)
        .shadow(color: Color.primary.opacity(0.2), radius: 1, x: 2, y: 2)
        .padding(.horizontal, 8)
    }
}

private extension PostRow {
    var productImage: some View {
        Image(image.image) // Use the post's imageNames
            .resizable()
            .scaledToFill()
            .frame(width: 140)
            .clipped()
    }
    
    var productDescription: some View {
        VStack(alignment: .leading) {
            Text(post.title)
                .font(.headline)
                .foregroundStyle(Color.black)
                .fontWeight(.medium)
                .padding(.bottom, 6)
            
            Text(post.text)
                .font(.footnote)
                .foregroundColor(.secondaryText)
            
            Spacer()
            footerView
        }
        .padding([.leading, .bottom], 12)
        .padding([.top, .trailing])
    }
    
    var footerView: some View {
        HStack(spacing: 0) {
            Text("₩").font(.footnote)
                .foregroundStyle(Color.black)
                + Text("\(post.price)").font(.headline)
                .foregroundStyle(Color.black)
            
            Spacer()
            
            if post.isFavorite {
                Image(systemName: "heart.fill")
                    .foregroundColor(Color.blue)
                    .frame(width: 32, height: 32)
            } else {
                Image(systemName: "heart")
                    .foregroundColor(Color.blue)
                    .frame(width: 32, height: 32)
            }
            
        }
    }
}


#Preview {
    PostRow(post: Post(id:9, title:"자전거", price:3000, isFavorite: false, text: "soososososo"), image: PostImage(id: 1, postId: 1, image: "cat1"))
}
