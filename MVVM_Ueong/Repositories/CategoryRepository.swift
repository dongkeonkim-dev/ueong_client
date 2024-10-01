//
//  CategoryRepository.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 10/1/24.
//

//import Foundation
//
//struct Category: Decodable {
//    let id: Int
//    let parentCategory
//    let address: String
//}
//
//class CategoryRepository {
//    // 비동기 함수로 특정 포스트의 주소를 가져오기
//    func getFullAddressById(emdId: Int) async throws -> String {
//        do {
//            let address: Address = try await APICall.shared.get("address/full-address-by-id", parameters: [emdId])
//            print("Successfully retrieved address: \(address.address) for emdId: \(emdId).")
//            return address.address
//        } catch {
//            print("Error fetching address for emdId \(emdId): \(error)")
//            throw error
//        }
//    }
//}
