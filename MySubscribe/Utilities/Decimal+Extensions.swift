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
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: self as NSDecimalNumber) ?? "$0.00"
    }
    
    var formattedAsShortCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = self.isWholeNumber ? 0 : 2
        formatter.minimumFractionDigits = self.isWholeNumber ? 0 : 2
        return formatter.string(from: self as NSDecimalNumber) ?? "$0"
    }
    
    private var isWholeNumber: Bool {
        let rounded = (self as NSDecimalNumber).rounding(accordingToBehavior: nil)
        return self == Decimal(rounded.intValue)
    }
}
