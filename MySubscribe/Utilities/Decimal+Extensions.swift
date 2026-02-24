//
//  Decimal+Extensions.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 15.01.2026.
//

import Foundation

extension Decimal {
    var formattedAsCurrency: String {
        CurrencyService.shared.format(self)
    }
    
    var formattedAsShortCurrency: String {
        let currencyService = CurrencyService.shared
        let convertedAmount = currencyService.convert(self, to: currencyService.selectedCurrencyCode)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyService.selectedCurrencyCode
        formatter.maximumFractionDigits = isWholeNumber(convertedAmount) ? 0 : 2
        formatter.minimumFractionDigits = isWholeNumber(convertedAmount) ? 0 : 2
        
        return formatter.string(from: convertedAmount as NSDecimalNumber) ?? "\(convertedAmount)"
    }
    
    private func isWholeNumber(_ value: Decimal) -> Bool {
        let rounded = (value as NSDecimalNumber).rounding(accordingToBehavior: nil)
        return value == Decimal(rounded.intValue)
    }
}
