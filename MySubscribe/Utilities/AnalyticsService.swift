//
//  AnalyticsService.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 19.01.2026.
//

import Foundation
import AmplitudeSwift

final class AnalyticsService {
    static let shared = AnalyticsService()
    private var amplitude: Amplitude?
    
    private init() {}
    
    func configure() {
        let apiKey = AnalyticsConfig.amplitudeAPIKey
        
        guard !apiKey.isEmpty, apiKey != "YOUR_API_KEY_HERE" else {
            #if DEBUG
            print("⚠️ Amplitude API key not configured")
            #endif
            return
        }
        
        amplitude = Amplitude(configuration: Configuration(
            apiKey: apiKey,
            serverZone: .EU,
            autocapture: [.sessions, .appLifecycles, .screenViews]
        ))
    }
    
    func track(_ event: AnalyticsEvent, properties: [String: Any]? = nil) {
        amplitude?.track(eventType: event.rawValue, eventProperties: properties)
    }
}

enum AnalyticsEvent: String {
    case subscriptionAdded = "subscription_added"
    case subscriptionDeleted = "subscription_deleted"
    case subscriptionEdited = "subscription_edited"
    case addSheetOpened = "add_sheet_opened"
    case detailViewOpened = "detail_view_opened"
}
