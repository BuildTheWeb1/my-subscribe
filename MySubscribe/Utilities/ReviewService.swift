//
//  ReviewService.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 19.01.2026.
//

import Foundation
import StoreKit
import OSLog

final class ReviewService {
    static let shared = ReviewService()
    
    private let logger = Logger(subsystem: "com.mysubscribe", category: "ReviewService")
    
    private let launchCountKey = "com.mysubscribe.launchCount"
    private let firstLaunchDateKey = "com.mysubscribe.firstLaunchDate"
    private let lastReviewRequestKey = "com.mysubscribe.lastReviewRequest"
    private let subscriptionAddedCountKey = "com.mysubscribe.subscriptionAddedCount"
    
    private let minimumLaunchCount = 3
    private let minimumSubscriptionsAdded = 2
    private let minimumDaysSinceInstall = 7
    private let minimumDaysBetweenRequests = 120
    
    private init() {}
    
    func recordAppLaunch() {
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: firstLaunchDateKey) == nil {
            defaults.set(Date(), forKey: firstLaunchDateKey)
            logger.info("First launch recorded")
        }
        
        let currentCount = defaults.integer(forKey: launchCountKey)
        defaults.set(currentCount + 1, forKey: launchCountKey)
        logger.info("App launch recorded. Total launches: \(currentCount + 1)")
    }
    
    func recordSubscriptionAdded() {
        let defaults = UserDefaults.standard
        let currentCount = defaults.integer(forKey: subscriptionAddedCountKey)
        defaults.set(currentCount + 1, forKey: subscriptionAddedCountKey)
        logger.info("Subscription added. Total: \(currentCount + 1)")
    }
    
    @MainActor
    func requestReviewIfAppropriate() {
        recordSubscriptionAdded()
        
        let (shouldRequest, reason) = evaluateReviewConditions()
        logger.info("Review evaluation: shouldRequest=\(shouldRequest), reason=\(reason)")
        
        guard shouldRequest else { return }
        
        presentReviewPrompt()
    }
    
    @MainActor
    func forceRequestReview() {
        logger.info("Force requesting review (debug only)")
        presentReviewPrompt()
    }
    
    @MainActor
    private func presentReviewPrompt() {
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(2))
            
            guard let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }) else {
                logger.warning("No active window scene found for review prompt")
                return
            }
            
            logger.info("Presenting review prompt")
            AppStore.requestReview(in: windowScene)
            UserDefaults.standard.set(Date(), forKey: lastReviewRequestKey)
        }
    }
    
    private func evaluateReviewConditions() -> (shouldRequest: Bool, reason: String) {
        let defaults = UserDefaults.standard
        
        let launchCount = defaults.integer(forKey: launchCountKey)
        guard launchCount >= minimumLaunchCount else {
            return (false, "Not enough launches: \(launchCount)/\(minimumLaunchCount)")
        }
        
        let subscriptionsAdded = defaults.integer(forKey: subscriptionAddedCountKey)
        guard subscriptionsAdded >= minimumSubscriptionsAdded else {
            return (false, "Not enough subscriptions added: \(subscriptionsAdded)/\(minimumSubscriptionsAdded)")
        }
        
        guard let firstLaunch = defaults.object(forKey: firstLaunchDateKey) as? Date else {
            return (false, "First launch date not recorded")
        }
        let daysSinceInstall = Calendar.current.dateComponents([.day], from: firstLaunch, to: Date()).day ?? 0
        guard daysSinceInstall >= minimumDaysSinceInstall else {
            return (false, "Not enough days since install: \(daysSinceInstall)/\(minimumDaysSinceInstall)")
        }
        
        if let lastRequest = defaults.object(forKey: lastReviewRequestKey) as? Date {
            let daysSinceLastRequest = Calendar.current.dateComponents([.day], from: lastRequest, to: Date()).day ?? 0
            guard daysSinceLastRequest >= minimumDaysBetweenRequests else {
                return (false, "Too soon since last request: \(daysSinceLastRequest)/\(minimumDaysBetweenRequests) days")
            }
        }
        
        return (true, "All conditions met")
    }
    
    func getDebugInfo() -> String {
        let defaults = UserDefaults.standard
        let launchCount = defaults.integer(forKey: launchCountKey)
        let subscriptionsAdded = defaults.integer(forKey: subscriptionAddedCountKey)
        let firstLaunch = defaults.object(forKey: firstLaunchDateKey) as? Date
        let lastRequest = defaults.object(forKey: lastReviewRequestKey) as? Date
        
        var info = "Review Service Debug Info:\n"
        info += "- Launch count: \(launchCount)\n"
        info += "- Subscriptions added: \(subscriptionsAdded)\n"
        info += "- First launch: \(firstLaunch?.formatted() ?? "nil")\n"
        info += "- Last review request: \(lastRequest?.formatted() ?? "never")\n"
        info += "- Mode: Production\n"
        
        let (_, reason) = evaluateReviewConditions()
        info += "- Current evaluation: \(reason)"
        
        return info
    }
    
    func resetForTesting() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: launchCountKey)
        defaults.removeObject(forKey: firstLaunchDateKey)
        defaults.removeObject(forKey: lastReviewRequestKey)
        defaults.removeObject(forKey: subscriptionAddedCountKey)
        logger.info("Review service data reset for testing")
    }
}
