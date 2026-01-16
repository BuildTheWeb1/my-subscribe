//
//  Subscription.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 15.01.2026.
//

import Foundation

struct Subscription: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var cost: Decimal
    var billingCycle: BillingCycle
    var category: SubscriptionCategory
    var customColor: String?
    var startDate: Date
    var createdAt: Date
    var updatedAt: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        cost: Decimal,
        billingCycle: BillingCycle = .monthly,
        category: SubscriptionCategory = .other,
        customColor: String? = nil,
        startDate: Date = Date(),
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.cost = cost
        self.billingCycle = billingCycle
        self.category = category
        self.customColor = customColor
        self.startDate = startDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    enum BillingCycle: String, Codable, CaseIterable, Identifiable {
        case monthly = "Monthly"
        case yearly = "Yearly"
        
        var id: String { rawValue }
        
        var monthlyMultiplier: Decimal {
            switch self {
            case .monthly: return 1
            case .yearly: return Decimal(1) / Decimal(12)
            }
        }
        
        var displaySuffix: String {
            switch self {
            case .monthly: return "/mo"
            case .yearly: return "/yr"
            }
        }
    }
    
    var monthlyAmount: Decimal {
        cost * billingCycle.monthlyMultiplier
    }
    
    var yearlyAmount: Decimal {
        monthlyAmount * 12
    }
    
    var paidSoFar: Decimal {
        let calendar = Calendar.current
        let now = Date()
        
        guard startDate <= now else { return 0 }
        
        let components = calendar.dateComponents([.month], from: startDate, to: now)
        let monthsPaid = max(1, (components.month ?? 0) + 1)
        
        switch billingCycle {
        case .monthly:
            return cost * Decimal(monthsPaid)
        case .yearly:
            let yearsPaid = (monthsPaid + 11) / 12
            return cost * Decimal(yearsPaid)
        }
    }
}

// MARK: - Sample Data
extension Subscription {
    static let samples: [Subscription] = [
        Subscription(name: "Netflix", cost: 15.99, billingCycle: .monthly, category: .streaming),
        Subscription(name: "Spotify", cost: 10.99, billingCycle: .monthly, category: .music),
        Subscription(name: "Adobe Creative Cloud", cost: 54.99, billingCycle: .monthly, category: .software),
        Subscription(name: "ChatGPT Plus", cost: 20.00, billingCycle: .monthly, category: .productivity),
        Subscription(name: "YouTube Premium", cost: 13.99, billingCycle: .monthly, category: .streaming),
        Subscription(name: "Gym Membership", cost: 29.99, billingCycle: .monthly, category: .fitness),
        Subscription(name: "Figma", cost: 12.00, billingCycle: .monthly, category: .software),
        Subscription(name: "NordVPN", cost: 96.00, billingCycle: .yearly, category: .software),
        Subscription(name: "Notion", cost: 8.00, billingCycle: .monthly, category: .productivity),
        Subscription(name: "Disney+", cost: 8.00, billingCycle: .monthly, category: .streaming),
        Subscription(name: "iCloud+", cost: 2.99, billingCycle: .monthly, category: .cloud),
        Subscription(name: "Amazon Prime", cost: 139.00, billingCycle: .yearly, category: .streaming)
    ]
}
