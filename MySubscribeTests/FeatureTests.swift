//
//  FeatureTests.swift
//  MySubscribeTests
//
//  Created by WebSpace Developer on 23.02.2026.
//

import Testing
import Foundation
@testable import MySubscribe

struct FeatureTests {
    
    // MARK: - Subscription Model Tests
    
    @Test func testNextRenewalDateMonthly() async throws {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .month, value: -2, to: Date())!
        
        let subscription = Subscription(
            name: "Test",
            cost: 10.00,
            billingCycle: .monthly,
            category: .streaming,
            startDate: startDate
        )
        
        // Next renewal should be in the future
        #expect(subscription.nextRenewalDate > Date())
        
        // Should be within the next month
        let daysUntilRenewal = calendar.dateComponents([.day], from: Date(), to: subscription.nextRenewalDate).day ?? 0
        #expect(daysUntilRenewal <= 31)
    }
    
    @Test func testNextRenewalDateYearly() async throws {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .month, value: -6, to: Date())!
        
        let subscription = Subscription(
            name: "Test Yearly",
            cost: 100.00,
            billingCycle: .yearly,
            category: .software,
            startDate: startDate
        )
        
        // Next renewal should be in the future
        #expect(subscription.nextRenewalDate > Date())
        
        // Should be within the next year
        let daysUntilRenewal = calendar.dateComponents([.day], from: Date(), to: subscription.nextRenewalDate).day ?? 0
        #expect(daysUntilRenewal <= 366)
    }
    
    // MARK: - Currency Model Tests
    
    @Test func testCurrencyLookup() async throws {
        let usd = Currency.currency(for: "USD")
        #expect(usd != nil)
        #expect(usd?.symbol == "$")
        #expect(usd?.name == "US Dollar")
        
        let eur = Currency.currency(for: "EUR")
        #expect(eur != nil)
        #expect(eur?.symbol == "€")
        
        let invalid = Currency.currency(for: "INVALID")
        #expect(invalid == nil)
    }
    
    @Test func testSupportedCurrenciesNotEmpty() async throws {
        #expect(!Currency.supportedCurrencies.isEmpty)
        #expect(Currency.supportedCurrencies.count >= 20)
    }
    
    // MARK: - Exchange Rate Response Tests
    
    @Test func testExchangeRateResponseDecoding() async throws {
        let json = """
        {
            "result": "success",
            "base_code": "USD",
            "time_last_update_unix": 1708646401,
            "rates": {
                "USD": 1.0,
                "EUR": 0.92,
                "GBP": 0.79
            }
        }
        """.data(using: .utf8)!
        
        let response = try JSONDecoder().decode(ExchangeRateResponse.self, from: json)
        
        #expect(response.result == "success")
        #expect(response.baseCode == "USD")
        #expect(response.rates["USD"] == 1.0)
        #expect(response.rates["EUR"] == 0.92)
        #expect(response.rates["GBP"] == 0.79)
    }
}
