//
//  ContentView.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 15.01.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var store = SubscriptionStore()
    
    var body: some View {
        HomeView(store: store)
    }
}

#Preview {
    ContentView()
}
