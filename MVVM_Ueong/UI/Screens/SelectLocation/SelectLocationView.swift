import SwiftUI
import MapKit

struct SelectLocation: View {
    @ObservedObject var wViewModel : WritePost.ViewModel
    @StateObject var sViewModel : SelectLocation.ViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    init(wViewModel: WritePost.ViewModel) {
        self.wViewModel = wViewModel
        _sViewModel = StateObject(wrappedValue: SelectLocation.ViewModel(
            latitude: wViewModel.post.latitude,
            longitude: wViewModel.post.longitude,
            locationDetail: wViewModel.post.locationDetail,
            emdId: wViewModel.post.emdId
        ))
    }
    
    var body: some View {
        VStack{
            ZStack {
                // 지도 영역을 정의합니다.
                GeometryReader { geometry in
                    // 옵셔널 바인딩을 통해 region을 안전하게 unwrap
//                    if var region = sViewModel.region {
                    Map(coordinateRegion: $sViewModel.region
//                                Binding(
//                            get: { sViewModel.region! },
//                            set: { newRegion in
//                                sViewModel.region = newRegion
//                                // 중심 좌표가 변경될 때마다 coordinate 업데이트
//                                sViewModel.coordinate = newRegion.center
//                            } )
                    , interactionModes: .all, showsUserLocation: false)
                        
                        // 핀의 위치를 현재 중심 좌표로 설정
                        MapPin()
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2 - 20)
                        
//                    }else{
//                        ProgressView("지도 정보를 불러오는 중입니다...")
//                            .frame(height: 200)
//                            .cornerRadius(10)
//                            .padding(.bottom, 20)
//                    }
                }
            }
            TextField("위치를 설명해 주세요.", text: $sViewModel.locationDetail)//$viewModel.post.locationDetail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .padding(.vertical, 5)
            Button(action:{
                Task{
                    await sViewModel.saveLocation()
                    presentationMode.wrappedValue.dismiss()
                }
            }){
                Text("선택 완료")
                    .font(.system(size: 20).weight(.bold))
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                .fill(sViewModel.locationDetail != "" ? Color.blue : Color.gray) // 조건부 배경 색상
            )
            .disabled(sViewModel.locationDetail.isEmpty)
            .padding(.horizontal)
            .foregroundColor(Color.white)
        }
        .onAppear {
            Task {
                sViewModel.delegate = wViewModel
            }
        }
    }
}

struct MapPin: View {
    var body: some View {
        Image(systemName: "mappin.and.ellipse") // Use any pin icon
            .resizable()
            .frame(width: 50, height: 60)
            .foregroundColor(.blue) // Change color if needed
            .padding(8)
            .clipShape(Circle())
            .shadow(radius: 3) // Add shadow for better visibility
    }
}
//#Preview {
//    SelectLocation(wViewModel: WritePost.ViewModel(village: Emd()), sViewModel: SelectLocation.ViewModel(emdId: Emd().id, wViewModel: self))
//}
