//
//  ContentView.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 15.01.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var store = SubscriptionStore()
    @State private var showSplash = true
    @State private var showOnboarding = false
    
    private var shouldShowOnboarding: Bool {
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "com.mysubscribe.onboardingCompleted")
        return !hasCompletedOnboarding || store.subscriptions.isEmpty
    }
    
    var body: some View {
        ZStack {
            HomeView(store: store)
            
            if showOnboarding {
                OnboardingView(isPresented: $showOnboarding)
                    .transition(.opacity)
                    .zIndex(2)
            }
            
            if showSplash {
                SplashScreenView(isActive: $showSplash)
                    .transition(.opacity)
                    .zIndex(3)
            }
        }
        .onChange(of: showSplash) { _, newValue in
            if !newValue && shouldShowOnboarding {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showOnboarding = true
                }
            }
        }
        .onChange(of: showOnboarding) { _, newValue in
            if !newValue {
                UserDefaults.standard.set(true, forKey: "com.mysubscribe.onboardingCompleted")
            }
        }
    }
}

#Preview {
    ContentView()
}
