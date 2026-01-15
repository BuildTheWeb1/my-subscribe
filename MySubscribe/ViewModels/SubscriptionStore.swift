//
//  SubscriptionStore.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 15.01.2026.
//

import Foundation
import SwiftUI

@Observable
@MainActor
final class SubscriptionStore {
    private(set) var subscriptions: [Subscription] = []
    
    private let storageKey = "com.mysubscribe.subscriptions"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init() {
        loadSubscriptions()
    }
    
    // MARK: - Computed Properties
    
    var totalMonthlySpending: Decimal {
        subscriptions.reduce(Decimal.zero) { $0 + $1.monthlyAmount }
    }
    
    var totalYearlyProjection: Decimal {
        totalMonthlySpending * 12
    }
    
    var subscriptionCount: Int {
        subscriptions.count
    }
    
    var sortedSubscriptions: [Subscription] {
        subscriptions.sorted { $0.monthlyAmount > $1.monthlyAmount }
    }
    
    // MARK: - CRUD Operations
    
    func addSubscription(_ subscription: Subscription) {
        subscriptions.append(subscription)
        saveSubscriptions()
    }
    
    func updateSubscription(_ subscription: Subscription) {
        guard let index = subscriptions.firstIndex(where: { $0.id == subscription.id }) else { return }
        var updated = subscription
        updated = Subscription(
            id: subscription.id,
            name: subscription.name,
            cost: subscription.cost,
            billingCycle: subscription.billingCycle,
            category: subscription.category,
            customColor: subscription.customColor,
            createdAt: subscription.createdAt,
            updatedAt: Date()
        )
        subscriptions[index] = updated
        saveSubscriptions()
    }
    
    func deleteSubscription(id: UUID) {
        subscriptions.removeAll { $0.id == id }
        saveSubscriptions()
    }
    
    func deleteSubscriptions(at offsets: IndexSet) {
        let sorted = sortedSubscriptions
        let idsToDelete = offsets.map { sorted[$0].id }
        subscriptions.removeAll { idsToDelete.contains($0.id) }
        saveSubscriptions()
    }
    
    // MARK: - Persistence
    
    private func loadSubscriptions() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            subscriptions = Subscription.samples
            return
        }
        
        do {
            subscriptions = try decoder.decode([Subscription].self, from: data)
        } catch {
            print("❌ Failed to load subscriptions: \(error)")
            subscriptions = []
        }
    }
    
    private func saveSubscriptions() {
        do {
            let data = try encoder.encode(subscriptions)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("❌ Failed to save subscriptions: \(error)")
        }
    }
    
    // MARK: - Debug
    
    func loadSampleData() {
        subscriptions = Subscription.samples
        saveSubscriptions()
    }
    
    func clearAllData() {
        subscriptions = []
        saveSubscriptions()
    }
}
