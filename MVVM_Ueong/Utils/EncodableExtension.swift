//
//  EncodableExtension.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 10/4/24.
//
extension Encodable {
    func toParams() -> [(String, Any)] {
        var parameters: [(String, Any)] = []
        let mirror = Mirror(reflecting: self)
        
        for child in mirror.children {
            parameters.append((child.label ?? "", child.value))
        }
        return parameters
    }
}

