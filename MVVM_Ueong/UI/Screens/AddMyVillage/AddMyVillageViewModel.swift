//
//  AddMyVillageViewModel.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 10/14/24.
//

import SwiftUI

extension AddMyVillage {
    class ViewModel: ObservableObject {
        @Published var searchTerm = ""
        @Published var addressList : [Address] = []
        @Published var selectedAddress : Address? = nil
        private let addressRepository = AddressRepository()
        private let myVillageRepository = MyVillageRepository()
        
        init() {
        }
        
        // 주소 검색 함수
        func searchAddress() async {
            do {
                let results = try await addressRepository.searchAddress(searchTerm: searchTerm)
                await MainActor.run {
                    self.addressList = results
                }
            } catch {
                print("Error searching address: \(error)")
            }
        }
        
        // 동네 추가 함수
        func addMyVillage() async {
            guard let selectedAddress = selectedAddress else { return }
            do {
                let response = try await myVillageRepository.addMyVillage(emdId: selectedAddress.id)
                print("Response: \(response)")
            } catch {
                print("Error adding village: \(error)")
            }
        }
    }
}

