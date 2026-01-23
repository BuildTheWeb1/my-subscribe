//
//  ReviewService.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 19.01.2026.
//

import Foundation
import StoreKit

final class ReviewService {
    static let shared = ReviewService()
    
    private let launchCountKey = "com.mysubscribe.launchCount"
    private let firstLaunchDateKey = "com.mysubscribe.firstLaunchDate"
    private let lastReviewRequestKey = "com.mysubscribe.lastReviewRequest"
    
    private let minimumLaunchCount = 5
    private let minimumDaysSinceInstall = 3
    private let minimumDaysBetweenRequests = 60
    
    private init() {}
    
    func recordAppLaunch() {
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: firstLaunchDateKey) == nil {
            defaults.set(Date(), forKey: firstLaunchDateKey)
        }
        
        let currentCount = defaults.integer(forKey: launchCountKey)
        defaults.set(currentCount + 1, forKey: launchCountKey)
    }
    
    @MainActor
    func requestReviewIfAppropriate() {
        guard shouldRequestReview() else { return }
        
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(1))
            if let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                AppStore.requestReview(in: windowScene)
                UserDefaults.standard.set(Date(), forKey: self.lastReviewRequestKey)
            }
        }
    }
    
    private func shouldRequestReview() -> Bool {
        let defaults = UserDefaults.standard
        
        let launchCount = defaults.integer(forKey: launchCountKey)
        guard launchCount >= minimumLaunchCount else {
            return false
        }
        
        guard let firstLaunch = defaults.object(forKey: firstLaunchDateKey) as? Date else {
            return false
        }
        let daysSinceInstall = Calendar.current.dateComponents([.day], from: firstLaunch, to: Date()).day ?? 0
        guard daysSinceInstall >= minimumDaysSinceInstall else {
            return false
        }
        
        if let lastRequest = defaults.object(forKey: lastReviewRequestKey) as? Date {
            let daysSinceLastRequest = Calendar.current.dateComponents([.day], from: lastRequest, to: Date()).day ?? 0
            guard daysSinceLastRequest >= minimumDaysBetweenRequests else {
                return false
            }
        }
        
        return true
    }
}
