//
//  MoneyFormatter.swift
//  MVVM_Ueong
//
//  Created by 김동건 on 10/5/24.
//

import Foundation

enum Position {
    case leading
    case trailing
}

struct MoneyFormatter {
    static func format(
        amount: Double,
        currencySymbol: String = "",
        symbolPosition: Position = .leading,
        includeComma: Bool = true
    ) -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0 // 소수점 없애기
        formatter.groupingSeparator = ","
        
        let formattedAmount = formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
        
        switch symbolPosition {
        case .leading:
            return "\(currencySymbol)\(formattedAmount)"
        case .trailing:
            return "\(formattedAmount)\(currencySymbol)"
        }
    }
}
