//
//  PostRow.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/25/24.
//

import SwiftUI

struct PostRow: View {
  @Binding var post: Post
  var togglePostsListFavorite: (Post) -> Void = { _ in }
  var inactivatePost: (Post) -> Void = { _ in }
  var refreshPostsList: () -> Void = {}
  let togglePostStatus: (Post) -> Void  // 매개변수 타입
  
  @State private var showOptions = false
  @State private var showDeleteConfirmation = false
  @State private var navigateToEdit = false
    //@GestureState private var isPressing = false // 길게 누르는 상태 추적
  
  
  var body: some View {
    if post.isActive {
      ZStack{
        NavigationLink(
          destination:
            PostDetail(
              postId: post.id,
              togglePostsListFavorite: togglePostsListFavorite // 좋아요 토글
            )
        ) {
          HStack {
            productImage
            productDescription
            NavigationLink(
              destination: WritePost(
                emdId: nil,
                postId: $post.id,
                addPostRow: {_ in},
                refreshPostsList: refreshPostsList
              ),
              isActive: $navigateToEdit
            ) {
              EmptyView()
            }
            .hidden()
          }
        }
        .contextMenu {
          if post.writerUsername == UserDefaultsManager.shared.getUsername() {
            Button(action: {
              navigateToEdit = true
            }) {
              Text("글 수정")
              Image(systemName: "pencil")
            }
            
            Button(action: {
              Task {
                togglePostStatus(post)  // post 매개변수 전달
              }
            }) {
              HStack {
                Text(post.status == "거래대기" ? "거래완료" : "거래대기")
                Image(systemName: post.status == "거래대기" ? "checkmark.circle" : "clock")
              }
              .foregroundColor(post.status == "거래대기" ? .blue : .gray)
            }
            
            Button(role: .destructive) {
              showDeleteConfirmation = true
            } label: {
              Text("삭제")
              Image(systemName: "trash")
            }
          }
        }
        .frame(height: 150)
        .background(Color.primary.colorInvert())
        .cornerRadius(6)
        .shadow(color: Color.primary.opacity(0.2), radius: 1, x: 2, y: 2)
        .padding(.horizontal, 8)
      }
      .alert(isPresented: $showDeleteConfirmation) {
        Alert(
          title: Text("삭제 확인"),
          message: Text("정말 이 게시물을 삭제하시겠습니까?"),
          primaryButton: .destructive(Text("삭제")) {
            inactivatePost(post)
          },
          secondaryButton: .cancel()
        )
      }
    } else {
      EmptyView()
    }
  }
}

private extension PostRow {
  var productImage: some View {
      // 포스트에 사진이 있는지 확인
    if let firstPhoto = post.photos?.first, let url = URL(string: baseURL.joinPath(firstPhoto.url)) {
        // AsyncImage를 사용하여 이미지 로드
        //                print(url)
      return AnyView(
        AsyncImage(url: url) { image in
          image
            .resizable()
            .scaledToFill()
            .frame(width: 140)
            .clipped()
        } placeholder: {
            // 로딩 중 대체 뷰
          ProgressView()
            .frame(width: 140, height: 140)
        }
          .onAppear {
            print("Attempting to load image from URL: \(url.absoluteString)")
          }
      )
    } else {
        // 기본 이미지를 반환
      return AnyView(
        Image(systemName: "photo.artframe") // 기본 이미지 사용
          .resizable()
          .scaledToFill()
          .frame(width: 140)
          .clipped()
          .foregroundColor(.gray) // 이미지 색상 설정
      )
    }
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
      + Text(MoneyFormatter.format(amount: post.price)).font(.headline)
        .foregroundStyle(Color.black)
      
      Spacer()
      
      Text("\(post.favoriteCount)")
      
      Button(action: {
        togglePostsListFavorite(post) // 뷰모델의 토글 메서드 호출
      }) {
        Image(systemName: post.isFavorite ? "heart.fill" : "heart")
          .foregroundColor(Color.blue)
          .frame(width: 32, height: 32)
      }
    }
  }
}

//#Preview {
//    // 임시로 사용할 Post 객체를 만들고 상태로 관리
//    @State var previewPost = Post()
//    PostRow(post: $previewPost, toggleFavorite: { _ in })
//}
