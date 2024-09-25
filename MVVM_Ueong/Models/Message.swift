//
//  Message.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 9/25/24.
//
import Foundation

struct Message: Identifiable {
    
    let id: Int
    let sender: String
    let text: String
    let sentTime: Date
}

