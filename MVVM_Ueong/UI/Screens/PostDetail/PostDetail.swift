//
//  PostDetail.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/25/24.
//

import SwiftUI
import MapKit


// MARK: - PostDetail
struct PostDetail: View {
    @ObservedObject var viewModel: PostDetail.ViewModel

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    PostImageSlider(photos: viewModel.post.photos ?? [])
                    UserInfoView(
                        writer: viewModel.writer,
                        siGuDong: viewModel.siGuDong
                    ) // 사용자 정보 추가
                    
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height: 1)
                        .padding(.horizontal, 20)
                    
                    PostDetailContent(
                        postTitle: viewModel.post.title,
                        postText: viewModel.post.text
                    ) // 포스트 상세 정보 추가
                    TradingLocation(
                        viewModel:viewModel
                    )
                }
                .onAppear {
                    viewModel.fetchPage()
                }
            }
            VStack(spacing: 20) {
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 1)
            }
            .padding(.bottom, 20)
        }
    }
}

// MARK: - PostImageSlider
struct PostImageSlider: View {
    var photos: [Photo]

    var body: some View {
        if photos.isEmpty {
            EmptyView()
        } else {
            TabView {
                ForEach(photos) { photo in
                    AsyncImage(url: URL(string: baseURL.joinPath(photo.url))) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                            .frame(width: UIScreen.main.bounds.width)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(height: 350)
        }
    }
}

// MARK: - UserInfoView
struct UserInfoView: View {
    var writer : User
    let siGuDong: String

    var body: some View {
        HStack {
            if let photoUrl = writer.profilePhotoUrl,
                let url = URL(string: baseURL.joinPath(photoUrl)) {
                // 서버에서 불러온 기존 이미지를 표시
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .padding(.trailing, 10)
                } placeholder: {
                    ProgressView()
                        .frame(width: 325, height: 325)
                }
            } else {
                // 기본 이미지
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .padding(.trailing, 10)
                    .foregroundColor(.gray)
            }
            
            
            VStack(alignment: .leading) {
                Text(writer.nickname)
                    .font(.system(size: 18, weight: .bold))
                Spacer().frame(height: 5)
                Text(siGuDong)
                    .font(.system(size: 14))
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - PostDetailContent
struct PostDetailContent: View {
    var postTitle: String
    var postText: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(postTitle)
                .font(.system(size: 28, weight: .bold))
                .fontWeight(.bold)
            
            HStack {
                Text("카테고리")
                    .foregroundColor(.gray)
                
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 1, height: 15)
                
                Text("13분전")
                    .foregroundColor(.gray)
            }
            .padding(.top, -10)
            
            VStack {
                Text(postText)
                    .font(.system(size: 20))
            }
            .padding(.top, 5)
        }
        .padding(.horizontal)
        
    }
}

// MARK: - TradingLocation
struct TradingLocation: View {
    @ObservedObject var viewModel: PostDetail.ViewModel
    var body: some View {
        VStack {
            Text("거래 희망 장소")
                .font(.system(size: 23, weight: .bold))
                .fontWeight(.bold)
                .padding(.top, 20)

            
            if let coordinate = viewModel.mapCoordinate {
                Map(initialPosition: .region(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)))) {
                    Marker(viewModel.post.title, coordinate: coordinate)
                        .tint(.blue)
                }
                .frame(height: 200)
                .cornerRadius(10)
                .padding(.bottom, 20)
            } else {
                ProgressView("지도 정보를 불러오는 중입니다...")
                    .frame(height: 200)
                    .cornerRadius(10)
                    .padding(.bottom, 20)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    PostDetail(viewModel: PostDetail.ViewModel(postId: 9))
}

