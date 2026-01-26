//
//  PopularSubscription.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 26.01.2026.
//

import Foundation

struct PriceTier: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let price: Decimal
    let billingCycle: Subscription.BillingCycle
    
    var displayPrice: String {
        price.formattedAsCurrency
    }
}

struct PopularSubscription: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let iconName: String
    let category: SubscriptionCategory
    let priceTiers: [PriceTier]
    let defaultTierIndex: Int
    
    var defaultTier: PriceTier {
        priceTiers[defaultTierIndex]
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func == (lhs: PopularSubscription, rhs: PopularSubscription) -> Bool {
        lhs.name == rhs.name
    }
}
