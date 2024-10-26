//
//  AddressRepository.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 10/1/24.
//

import Foundation

struct Address: Decodable, Identifiable {

    let id: Int
    let Address: String
    
    enum CodingKeys: String, CodingKey {
        case id = "emd_id"
        case Address = "fullAddress"
    }
}

class AddressRepository {
    // 비동기 함수로 특정 포스트의 주소를 가져오기
    func getFullAddress(emdId: Int) async throws -> String {
        do {
            let address: Address = try await APICall.shared.get("address/full", parameters: [("emd_id",emdId)])
//            print("Successfully retrieved address: \(address.Address) for emdId: \(emdId).")
            return address.Address
        } catch {
            print("Error fetching address for emdId \(emdId): \(error)")
            throw error
        }
    }
    
    func searchAddress(searchTerm: String) async throws -> [Address] {
        let addressList: [Address] = try await APICall.shared.get("address/search", queryParameters: ["search_term": searchTerm])
        return addressList
    }
    
    func getEmd(emdId: Int) async throws -> Emd {
        let emd: Emd = try await APICall.shared.get("address/emd", parameters: [("emd_id", emdId)])
        return emd
    }
}
