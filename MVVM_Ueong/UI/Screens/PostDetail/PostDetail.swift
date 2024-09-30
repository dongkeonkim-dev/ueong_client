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
                        writerUsername:viewModel.post.writerUsername,
                        emd_name: "충주시 단월동"
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
                        postTitle: viewModel.post.title,
                        location: viewModel.post.location
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
                    AsyncImage(url: URL(string: baseURL + photo.url)) { image in
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
    var writerUsername : String
    let emd_name: String

    var body: some View {
        HStack {
            Image("cat2")
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .padding(.trailing, 10)

            VStack(alignment: .leading) {
                Text(writerUsername)
                    .font(.system(size: 18, weight: .bold))
                Spacer().frame(height: 5)
                Text(emd_name)
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
    var postTitle: String
    var location: CLLocationCoordinate2D
    var body: some View {
        VStack {
            Text("거래 희망 장소")
                .font(.system(size: 23, weight: .bold))
                .fontWeight(.bold)
                .padding(.top, 20)

            
            Map(initialPosition: .region(MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)))) {
                Marker(postTitle, coordinate: location)
                        .tint(.blue)
                }
                .frame(height: 200)
                .cornerRadius(10)
                .padding(.bottom, 20)
            
        }
        .padding(.horizontal)
    }
}

#Preview {
    PostDetail(viewModel: PostDetail.ViewModel(postId: 9))
}

