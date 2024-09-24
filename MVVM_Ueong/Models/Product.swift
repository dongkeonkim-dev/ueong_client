//
//  Product.swift
//  MVVM_Ueong
//
//  Created by 김석원 on 9/24/24.
//
import Foundation

struct Product: Identifiable {
    
    let id: UUID
    let name: String
    let price: Double
    let isFavorite: Bool

}
