//
//  SubscriptionStore.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 15.01.2026.
//

import Foundation
import SwiftUI
import WidgetKit

@Observable
@MainActor
final class SubscriptionStore {
    private(set) var subscriptions: [Subscription] = []
    private(set) var loadError: String?
    private(set) var saveError: String?
    private(set) var recentlyModifiedId: UUID?
    
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
        recentlyModifiedId = subscription.id
        AnalyticsService.shared.track(.subscriptionAdded, properties: [
            "category": subscription.category.rawValue,
            "billing_cycle": subscription.billingCycle.rawValue
        ])
        ReviewService.shared.requestReviewIfAppropriate()
    }
    
    func updateSubscription(_ subscription: Subscription) {
        guard let index = subscriptions.firstIndex(where: { $0.id == subscription.id }) else { return }
        let updated = Subscription(
            id: subscription.id,
            name: subscription.name,
            cost: subscription.cost,
            billingCycle: subscription.billingCycle,
            category: subscription.category,
            customColor: subscription.customColor,
            startDate: subscription.startDate,
            createdAt: subscription.createdAt,
            updatedAt: Date()
        )
        subscriptions[index] = updated
        saveSubscriptions()
        recentlyModifiedId = subscription.id
        AnalyticsService.shared.track(.subscriptionEdited, properties: [
            "category": subscription.category.rawValue
        ])
    }
    
    func deleteSubscription(id: UUID) {
        let category = subscriptions.first(where: { $0.id == id })?.category.rawValue
        subscriptions.removeAll { $0.id == id }
        saveSubscriptions()
        AnalyticsService.shared.track(.subscriptionDeleted, properties: [
            "category": category ?? "unknown"
        ])
    }
    
    func deleteSubscriptions(at offsets: IndexSet) {
        let sorted = sortedSubscriptions
        let idsToDelete = offsets.map { sorted[$0].id }
        subscriptions.removeAll { idsToDelete.contains($0.id) }
        saveSubscriptions()
    }
    
    // MARK: - Persistence
    
    private func loadSubscriptions() {
        loadError = nil
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            subscriptions = []
            return
        }
        
        do {
            subscriptions = try decoder.decode([Subscription].self, from: data)
        } catch {
            print("❌ Failed to load subscriptions: \(error)")
            loadError = String(localized: "Unable to load your subscriptions. Data may be corrupted.")
            subscriptions = []
        }
    }
    
    func retryLoad() {
        loadSubscriptions()
    }
    
    private func saveSubscriptions() {
        saveError = nil
        do {
            let data = try encoder.encode(subscriptions)
            UserDefaults.standard.set(data, forKey: storageKey)
            updateWidgetData()
        } catch {
            print("❌ Failed to save subscriptions: \(error)")
            saveError = String(localized: "Unable to save changes. Please try again.")
        }
    }
    
    private func updateWidgetData() {
        let upcomingRenewals = subscriptions
            .sorted { $0.nextRenewalDate < $1.nextRenewalDate }
            .prefix(5)
            .map { subscription in
                WidgetRenewalItem(
                    id: subscription.id,
                    name: subscription.name,
                    amount: subscription.monthlyAmount,
                    renewalDate: subscription.nextRenewalDate,
                    categoryIcon: subscription.category.systemIcon,
                    categoryColorHex: subscription.category.colorHex
                )
            }
        
        let widgetData = WidgetSubscriptionData(
            totalMonthly: totalMonthlySpending,
            totalYearly: totalYearlyProjection,
            subscriptionCount: subscriptionCount,
            upcomingRenewals: Array(upcomingRenewals),
            currencyCode: CurrencyService.shared.selectedCurrencyCode,
            lastUpdated: Date()
        )
        
        WidgetDataProvider.save(widgetData)
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func dismissSaveError() {
        saveError = nil
    }
    
    func clearRecentlyModified() {
        recentlyModifiedId = nil
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
