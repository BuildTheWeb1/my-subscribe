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
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
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
                    
                    HeaderView(
                        totalMonthly: store.totalMonthlySpending,
                        totalYearly: store.totalYearlyProjection,
                        subscriptionCount: store.subscriptionCount
                    )
                }
                .padding(16)
            }
            .background(AppColors.background)
            .navigationTitle("MySubscribe")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(AppColors.coral)
                    }
                    .accessibilityLabel("Add subscription")
                }
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
        }
    }
}

#Preview {
    HomeView(store: SubscriptionStore())
}
