//
//  CurrencyService.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 23.02.2026.
//

import Foundation
import OSLog
import SwiftUI

// MARK: - Environment Key
private struct CurrencyServiceKey: EnvironmentKey {
    static let defaultValue = CurrencyService.shared
}

extension EnvironmentValues {
    var currencyService: CurrencyService {
        get { self[CurrencyServiceKey.self] }
        set { self[CurrencyServiceKey.self] = newValue }
    }
}

@Observable @MainActor
final class CurrencyService {
    static let shared = CurrencyService()
    
    private let logger = Logger(subsystem: "com.mysubscribe", category: "Currency")
    private let apiURL = "https://open.er-api.com/v6/latest/USD"
    private let ratesKey = "com.mysubscribe.cachedRates"
    private let lastUpdatedKey = "com.mysubscribe.ratesLastUpdated"
    private let selectedCurrencyKey = "com.mysubscribe.selectedCurrency"
    
    private(set) var rates: [String: Double] = [:]
    private(set) var lastUpdated: Date?
    private(set) var isLoading = false
    private(set) var error: String?
    
    private(set) var selectedCurrencyCode: String = "USD"
    
    var selectedCurrency: Currency {
        Currency.currency(for: selectedCurrencyCode) ?? Currency.supportedCurrencies[0]
    }
    
    private init() {
        self.selectedCurrencyCode = UserDefaults.standard.string(forKey: selectedCurrencyKey) ?? "USD"
        loadCachedRates()
    }
    
    func setSelectedCurrency(_ code: String) {
        guard code != selectedCurrencyCode else { return }
        selectedCurrencyCode = code
        UserDefaults.standard.set(code, forKey: selectedCurrencyKey)
        logger.info("Selected currency changed to: \(code)")
    }
    
    func fetchRatesIfNeeded() async {
        if let lastUpdated = lastUpdated {
            let hoursSinceUpdate = Calendar.current.dateComponents([.hour], from: lastUpdated, to: Date()).hour ?? 0
            if hoursSinceUpdate < 24 && !rates.isEmpty {
                logger.info("Using cached rates (updated \(hoursSinceUpdate) hours ago)")
                return
            }
        }
        
        await fetchRates()
    }
    
    func fetchRates() async {
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        
        defer { isLoading = false }
        
        guard let url = URL(string: apiURL) else {
            error = "Invalid API URL"
            logger.error("Invalid API URL")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                error = "Failed to fetch rates"
                logger.error("HTTP error fetching rates")
                return
            }
            
            let decoded = try JSONDecoder().decode(ExchangeRateResponse.self, from: data)
            
            guard decoded.result == "success" else {
                error = "API returned error"
                logger.error("API returned non-success result")
                return
            }
            
            rates = decoded.rates
            lastUpdated = Date()
            
            cacheRates()
            
            logger.info("Fetched \(self.rates.count) exchange rates")
            
        } catch {
            self.error = "Failed to fetch rates: \(error.localizedDescription)"
            logger.error("Error fetching rates: \(error.localizedDescription)")
        }
    }
    
    func convert(_ amount: Decimal, from sourceCurrency: String = "USD", to targetCurrency: String) -> Decimal {
        guard sourceCurrency != targetCurrency else { return amount }
        
        guard let sourceRate = rates[sourceCurrency],
              let targetRate = rates[targetCurrency],
              sourceRate > 0 else {
            return amount
        }
        
        let amountInUSD = Double(truncating: amount as NSDecimalNumber) / sourceRate
        let convertedAmount = amountInUSD * targetRate
        
        return Decimal(convertedAmount)
    }
    
    func format(_ amount: Decimal, in currencyCode: String? = nil) -> String {
        let code = currencyCode ?? selectedCurrencyCode
        let convertedAmount = convert(amount, to: code)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = code
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        return formatter.string(from: convertedAmount as NSDecimalNumber) ?? "\(convertedAmount)"
    }
    
    private func cacheRates() {
        if let data = try? JSONEncoder().encode(rates) {
            UserDefaults.standard.set(data, forKey: ratesKey)
        }
        UserDefaults.standard.set(lastUpdated, forKey: lastUpdatedKey)
        logger.info("Cached exchange rates")
    }
    
    private func loadCachedRates() {
        if let data = UserDefaults.standard.data(forKey: ratesKey),
           let cached = try? JSONDecoder().decode([String: Double].self, from: data) {
            rates = cached
            logger.info("Loaded \(cached.count) cached rates")
        }
        
        lastUpdated = UserDefaults.standard.object(forKey: lastUpdatedKey) as? Date
    }
}
