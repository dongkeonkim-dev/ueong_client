//
//  AddressRepository.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 10/1/24.
//

import Foundation

struct Address: Decodable {
    let Address: String
}

class AddressRepository {
    // 비동기 함수로 특정 포스트의 주소를 가져오기
    func getFullAddress(emdId: Int) async throws -> String {
        do {
            let address: Address = try await APICall.shared.get("address", parameters: [("emdId",emdId)])
//            print("Successfully retrieved address: \(address.Address) for emdId: \(emdId).")
            return address.Address
        } catch {
            print("Error fetching address for emdId \(emdId): \(error)")
            throw error
        }
    }
}
