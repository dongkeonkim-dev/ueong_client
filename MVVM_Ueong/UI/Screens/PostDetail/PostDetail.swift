//
//  PostDetail.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/25/24.
//

import SwiftUI
import MapKit

struct PostDetail: View {
    @ObservedObject var viewModel: PostDetail.ViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // 이미지 슬라이더
                        if let photos = viewModel.post.photos { // 이미지 이름을 안전하게 추출
                            TabView {
                                
                                ForEach(photos) { photo in // 이미지 이름 배열을 사용
                                    AsyncImage(url: URL(string: baseURL + photo.url)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: UIScreen.main.bounds.width)
                                            .clipped()
                                    } placeholder: {
                                        // 로딩 중 대체 뷰
                                        ProgressView()
                                            .frame(width: UIScreen.main.bounds.width)
                                    }
                                }
                            }
                            .tabViewStyle(PageTabViewStyle())
                            .frame(height: 350)
                        } else {
                            Text("이미지가 없습니다") // 이미지가 없을 경우의 대체 텍스트
                        }
                        
                        HStack {
                            Image("cat2")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .padding(.trailing, 10)
                            
                            VStack(alignment: .leading) { // 왼쪽 정렬을 위해 alignment 설정
                                Text("귀여운고양이")
                                    .font(.system(size: 18, weight: .bold))
                                Spacer().frame(height: 5) // 텍스트 사이의 간격
                                Text("충주시 단월동")
                                    .font(.system(size: 14))
                                    
                            }
                        }
                        .padding(.horizontal)
                        
                        // 밑줄 추가
                        Rectangle()
                            .fill(Color.gray) // 색상 설정
                            .frame(height: 1) // 선 두께 설정
                            .padding(.horizontal, 20) // 좌우 패딩
                        
                        // 포스트 상세 정보
                            VStack(alignment: .leading) {
                                // 제목
                                Text(viewModel.post.title)
                                    .font(.system(size: 28, weight: .bold))
                                    .fontWeight(.bold)
                                
                                HStack {
                                    Text("카테고리")
                                        .foregroundColor(.gray)
                                    
                                    // 세로줄 추가
                                    Rectangle()
                                        .fill(Color.gray) // 색상 설정
                                        .frame(width: 1, height: 15) // 세로줄의 너비와 높이 설정
                                    
                                    Text("13분전")
                                        .foregroundColor(.gray)
                                }
                                .padding(.top, -10)
                                
                                VStack {
                                    Text(viewModel.post.text)
                                        .font(.system(size: 20))
                                }
                                .padding(.top, 5)
                                
                                Text("거래 희망 장소")
                                    .font(.system(size: 23, weight: .bold))
                                    .fontWeight(.bold)
                                    .padding(.top, 20)
                                
                                // 지도
                                Map(initialPosition: .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: viewModel.post.latitude, longitude: viewModel.post.longitude), span: (MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))))) {
                                    Marker(viewModel.post.title, coordinate: CLLocationCoordinate2D(latitude: viewModel.post.latitude, longitude: viewModel.post.longitude))
                                        .tint(.blue)
                                }
                                .frame(height: 200)
                                .cornerRadius(10)
                                .padding(.bottom, 20)
                            }
                            .padding(.horizontal)
                    }
                }
                
                VStack(spacing: 20) {
                    // 밑줄 추가
                    Rectangle()
                        .fill(Color.gray) // 색상 설정
                        .frame(height: 1) // 선 두께 설정
                    
                    HStack {
                        // 좋아요
                        if false {
                            Image(systemName: "heart.fill")
                                .resizable() // 크기를 조절 가능하게 함
                                .frame(width: 25, height: 25) // 원하는 크기로 조절
                                .foregroundColor(.red)
                        } else {
                            Image(systemName: "heart")
                                .resizable() // 크기를 조절 가능하게 함
                                .frame(width: 25, height: 25) // 원하는 크기로 조절
                                .foregroundColor(.red)
                        }
                        
                        // 세로줄 추가
                        Rectangle()
                            .fill(Color.gray) // 색상 설정
                            .frame(width: 1, height: 40) // 세로줄의 너비와 높이 설정
                            .padding(.horizontal, 10)
                        
                        Text("130,000원")
                            .font(.system(size: 19, weight: .bold))
                        
                        Spacer() // 왼쪽 요소와 오른쪽 요소 사이에 공간 추가
                        
                        // AR모델 확인하기 (현재 모델이 없는 상태)
                        Button(action: {
                            // AR 버튼 클릭 시 실행할 코드
                            print("AR")
                        }) {
                            Text("AR")
                                .frame(width: 40) // Set explicit width and height
                                .padding(10) // 버튼의 패딩
                                .foregroundColor(.white) // 버튼의 텍스트 색상
                                .cornerRadius(5) // 버튼의 모서리 둥글기
                                .background(false ? Color.blue : Color.gray)
                        }
                        .disabled(true) // 3D모델이 있으면 버튼 활성화 (현재 없는 상태)
                        
                        Button(action: {
                            // 채팅하기 버튼 클릭 시 실행할 코드
                            print("채팅하기 버튼 클릭")
                        }) {
                            Text("채팅하기")
                                .padding(10) // 버튼의 패딩
                                .background(Color.blue) // 버튼의 배경 색상
                                .foregroundColor(.white) // 버튼의 텍스트 색상
                                .cornerRadius(5) // 버튼의 모서리 둥글기
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    PostDetail(viewModel: PostDetail.ViewModel(post: Post(
        id: 9,
        title: "자전거",
        category: 1,
        price: 3000.0,
        emdId: 1,
        latitude: 37.5,
        longitude: 160.0,
        locationDetail: "아무데나",
        createAt: Date(), // Date()로 초기화
        isFavorite: false,
        text: "soososososo",
        photos: [
            Photo(id: 1, postId: 1, url: "cat1.jpg") // 여기에 사진의 URL을 적어주세요
        ]
    )))
}

