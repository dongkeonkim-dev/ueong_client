//
//  SelectLocationViewModel.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 10/7/24.
//

import SwiftUI
import MapKit

extension SelectLocation {
    class ViewModel: ObservableObject {
        @Published var emdId: Int
        @Published var locationDetail: String = ""
        @Published var coordinate: CLLocationCoordinate2D?
        @Published var region: MKCoordinateRegion // 중심 좌표를 나타내는 상태 변수
        weak var delegate: WritePostViewModelDelegate?
        
        var username: String
        
        let emdRepository = EmdRepository()

        init(emdId: Int) {
            self.username = "username1"
            self.emdId = emdId
            self.region = MKCoordinateRegion(center:CLLocationCoordinate2D(latitude: 0, longitude: 0), span:MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
            Task{
                await loadEmdCoordinate()
            }
        }
        
        func loadEmdCoordinate() async {
            Task{ @MainActor in
                let emd = try await emdRepository.getEmd(emdId: emdId)
                if coordinate == nil {
                    self.coordinate = CLLocationCoordinate2D(latitude: emd.latitude, longitude: emd.longitude)
                    print(coordinate!.latitude, coordinate!.longitude) // Optional(37.58008) Optional(126.9848)
                }
                self.region.center = self.coordinate!
                self.region.span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
                print(region.center.latitude, region.center.longitude) // 37.58008 126.9848
            }
        }
        
        func saveLocation() async {
            print("start save")
            delegate?.didUpdateLocation(latitude: region.center.latitude, longitude: region.center.longitude, locationDetail: locationDetail)
        }
    }
}
