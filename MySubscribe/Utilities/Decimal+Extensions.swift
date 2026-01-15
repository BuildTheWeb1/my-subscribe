//
//  Decimal+Extensions.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 15.01.2026.
//

import Foundation

extension Decimal {
    var formattedAsCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        let number = formatter.string(from: self as NSDecimalNumber) ?? "0.00"
        return "$\(number)"
    }
    
    var formattedAsShortCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = isWholeNumber ? 0 : 2
        formatter.minimumFractionDigits = isWholeNumber ? 0 : 2
        let number = formatter.string(from: self as NSDecimalNumber) ?? "0"
        return "$\(number)"
    }
    
    private var isWholeNumber: Bool {
        let rounded = (self as NSDecimalNumber).rounding(accordingToBehavior: nil)
        return self == Decimal(rounded.intValue)
    }
}
