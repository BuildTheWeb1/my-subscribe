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
    
    var body: some View {
        ZStack {
            HomeView(store: store)
            
            if showSplash {
                SplashScreenView(isActive: $showSplash)
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
    }
}

#Preview {
    ContentView()
}
