//
//  MySubscribeApp.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 15.01.2026.
//

import SwiftUI

@main
struct MySubscribeApp: App {
    
    init() {
        AnalyticsService.shared.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
