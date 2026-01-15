//
//  HomeView.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 15.01.2026.
//

import SwiftUI

struct HomeView: View {
    var store: SubscriptionStore
    @State private var showingAddSheet = false
    @State private var selectedSubscription: Subscription?
    @State private var subscriptionToDelete: Subscription?
    @State private var showingDeleteAlert = false
    #if DEBUG
    @State private var showingDebugConsole = false
    #endif
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    HeaderView(
                        totalMonthly: store.totalMonthlySpending,
                        totalYearly: store.totalYearlyProjection,
                        subscriptionCount: store.subscriptionCount,
                        onAddTapped: {
                            showingAddSheet = true
                        }
                    )
                    
                    SubscriptionGridView(
                        subscriptions: store.subscriptions,
                        totalMonthly: store.totalMonthlySpending,
                        onTap: { subscription in
                            selectedSubscription = subscription
                        },
                        onDelete: { id in
                            if let sub = store.subscriptions.first(where: { $0.id == id }) {
                                subscriptionToDelete = sub
                                showingDeleteAlert = true
                            }
                        }
                    )
                }
                .padding(16)
                .animation(.easeInOut(duration: 0.3), value: store.subscriptions.count)
            }
            .scrollIndicators(.hidden)
            .background(Color.white)
//            .navigationTitle("MySubscribe")
            .toolbar {
                #if DEBUG
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingDebugConsole = true
                    } label: {
                        Image(systemName: "ladybug")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color.black)
                    }
                    .accessibilityLabel("Debug console")
                }
                #endif
            }
            .sheet(isPresented: $showingAddSheet) {
                AddSubscriptionView(store: store)
            }
            .sheet(item: $selectedSubscription) { subscription in
                SubscriptionDetailView(
                    store: store,
                    subscription: subscription
                )
            }
            .alert("Delete Subscription", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {
                    subscriptionToDelete = nil
                }
                Button("Delete", role: .destructive) {
                    if let sub = subscriptionToDelete {
                        withAnimation {
                            store.deleteSubscription(id: sub.id)
                        }
                    }
                    subscriptionToDelete = nil
                }
            } message: {
                if let sub = subscriptionToDelete {
                    Text("Are you sure you want to delete \(sub.name)?")
                }
            }
            #if DEBUG
            .sheet(isPresented: $showingDebugConsole) {
                DebugConsoleView(subscriptions: store.subscriptions)
            }
            #endif
        }
    }
}

#Preview {
    HomeView(store: SubscriptionStore())
}
