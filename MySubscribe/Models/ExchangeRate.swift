//
//  ExchangeRate.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 23.02.2026.
//

import Foundation

struct ExchangeRateResponse: Codable {
    let result: String
    let baseCode: String
    let timeLastUpdateUnix: Int
    let rates: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case result
        case baseCode = "base_code"
        case timeLastUpdateUnix = "time_last_update_unix"
        case rates
    }
}

struct Currency: Identifiable, Hashable {
    let code: String
    let name: String
    let symbol: String
    
    var id: String { code }
    
    static let supportedCurrencies: [Currency] = [
        Currency(code: "USD", name: "US Dollar", symbol: "$"),
        Currency(code: "EUR", name: "Euro", symbol: "€"),
        Currency(code: "GBP", name: "British Pound", symbol: "£"),
        Currency(code: "JPY", name: "Japanese Yen", symbol: "¥"),
        Currency(code: "CAD", name: "Canadian Dollar", symbol: "CA$"),
        Currency(code: "AUD", name: "Australian Dollar", symbol: "A$"),
        Currency(code: "CHF", name: "Swiss Franc", symbol: "CHF"),
        Currency(code: "CNY", name: "Chinese Yuan", symbol: "¥"),
        Currency(code: "INR", name: "Indian Rupee", symbol: "₹"),
        Currency(code: "MXN", name: "Mexican Peso", symbol: "MX$"),
        Currency(code: "BRL", name: "Brazilian Real", symbol: "R$"),
        Currency(code: "KRW", name: "South Korean Won", symbol: "₩"),
        Currency(code: "SGD", name: "Singapore Dollar", symbol: "S$"),
        Currency(code: "HKD", name: "Hong Kong Dollar", symbol: "HK$"),
        Currency(code: "NOK", name: "Norwegian Krone", symbol: "kr"),
        Currency(code: "SEK", name: "Swedish Krona", symbol: "kr"),
        Currency(code: "DKK", name: "Danish Krone", symbol: "kr"),
        Currency(code: "NZD", name: "New Zealand Dollar", symbol: "NZ$"),
        Currency(code: "ZAR", name: "South African Rand", symbol: "R"),
        Currency(code: "RUB", name: "Russian Ruble", symbol: "₽"),
        Currency(code: "TRY", name: "Turkish Lira", symbol: "₺"),
        Currency(code: "PLN", name: "Polish Zloty", symbol: "zł"),
        Currency(code: "THB", name: "Thai Baht", symbol: "฿"),
        Currency(code: "IDR", name: "Indonesian Rupiah", symbol: "Rp"),
        Currency(code: "CZK", name: "Czech Koruna", symbol: "Kč"),
        Currency(code: "ILS", name: "Israeli Shekel", symbol: "₪"),
        Currency(code: "PHP", name: "Philippine Peso", symbol: "₱"),
        Currency(code: "RON", name: "Romanian Leu", symbol: "lei"),
        Currency(code: "HUF", name: "Hungarian Forint", symbol: "Ft")
    ]
    
    static func currency(for code: String) -> Currency? {
        supportedCurrencies.first { $0.code == code }
    }
}
