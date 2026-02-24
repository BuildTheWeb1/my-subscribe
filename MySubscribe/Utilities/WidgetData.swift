//
//  WidgetData.swift
//  MySubscribe
//
//  Shared data structures for widget communication
//

import Foundation

/// Data structure shared between main app and widget
struct WidgetSubscriptionData: Codable {
    let totalMonthly: Decimal
    let totalYearly: Decimal
    let subscriptionCount: Int
    let upcomingRenewals: [WidgetRenewalItem]
    let currencyCode: String
    let lastUpdated: Date
    
    static let empty = WidgetSubscriptionData(
        totalMonthly: 0,
        totalYearly: 0,
        subscriptionCount: 0,
        upcomingRenewals: [],
        currencyCode: "USD",
        lastUpdated: Date()
    )
    
    static let placeholder = WidgetSubscriptionData(
        totalMonthly: 68.98,
        totalYearly: 827.76,
        subscriptionCount: 7,
        upcomingRenewals: [
            WidgetRenewalItem(
                id: UUID(),
                name: "Netflix",
                amount: 15.99,
                renewalDate: Date().addingTimeInterval(86400 * 3),
                categoryIcon: "play.tv.fill",
                categoryColorHex: "FF6B6B"
            ),
            WidgetRenewalItem(
                id: UUID(),
                name: "Spotify",
                amount: 10.99,
                renewalDate: Date().addingTimeInterval(86400 * 7),
                categoryIcon: "music.note",
                categoryColorHex: "4ECDC4"
            ),
            WidgetRenewalItem(
                id: UUID(),
                name: "iCloud+",
                amount: 2.99,
                renewalDate: Date().addingTimeInterval(86400 * 12),
                categoryIcon: "cloud.fill",
                categoryColorHex: "5B8DEF"
            )
        ],
        currencyCode: "USD",
        lastUpdated: Date()
    )
}

struct WidgetRenewalItem: Codable, Identifiable {
    let id: UUID
    let name: String
    let amount: Decimal
    let renewalDate: Date
    let categoryIcon: String
    let categoryColorHex: String
}

/// Shared constants for App Group communication
enum SharedConstants {
    static let appGroupIdentifier = "group.com.WebSpace.MySubscribe"
    static let widgetDataKey = "com.mysubscribe.widgetData"
    
    static var sharedDefaults: UserDefaults? {
        UserDefaults(suiteName: appGroupIdentifier)
    }
}

/// Helper to save/load widget data
enum WidgetDataProvider {
    
    static func save(_ data: WidgetSubscriptionData) {
        guard let defaults = SharedConstants.sharedDefaults else { return }
        
        do {
            let encoded = try JSONEncoder().encode(data)
            defaults.set(encoded, forKey: SharedConstants.widgetDataKey)
        } catch {
            print("❌ Failed to save widget data: \(error)")
        }
    }
    
    static func load() -> WidgetSubscriptionData {
        guard let defaults = SharedConstants.sharedDefaults,
              let data = defaults.data(forKey: SharedConstants.widgetDataKey) else {
            return .empty
        }
        
        do {
            return try JSONDecoder().decode(WidgetSubscriptionData.self, from: data)
        } catch {
            print("❌ Failed to load widget data: \(error)")
            return .empty
        }
    }
}
