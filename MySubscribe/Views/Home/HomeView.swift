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
    @State private var showingSaveErrorAlert = false
    @State private var showingChartsSheet = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    #if DEBUG
    @State private var showingDebugConsole = false
    #endif
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(spacing: 20) {
                        Color.clear
                            .frame(height: 220)
                        
                        SubscriptionGridView(
                            subscriptions: store.subscriptions,
                            totalMonthly: store.totalMonthlySpending,
                            loadError: store.loadError,
                            recentlyModifiedId: store.recentlyModifiedId,
                            onTap: { subscription in
                                selectedSubscription = subscription
                                AnalyticsService.shared.track(.detailViewOpened, properties: [
                                    "category": subscription.category.rawValue
                                ])
                            },
                            onDelete: { id in
                                if let sub = store.subscriptions.first(where: { $0.id == id }) {
                                    subscriptionToDelete = sub
                                    showingDeleteAlert = true
                                }
                            },
                            onRetry: {
                                store.retryLoad()
                            }
                        )
                    }
                    .padding(16)
                    .animation(reduceMotion ? nil : .easeInOut(duration: 0.3), value: store.subscriptions.count)
                }
                .scrollIndicators(.hidden)
                
                HeaderView(
                    totalMonthly: store.totalMonthlySpending,
                    totalYearly: store.totalYearlyProjection,
                    subscriptionCount: store.subscriptionCount,
                    onAddTapped: {
                        showingAddSheet = true
                        AnalyticsService.shared.track(.addSheetOpened)
                    }
                )
                .padding(.horizontal, 16)
            }
            .background(AppColors.background)
//            .navigationTitle("MySubscribe")
            .toolbar {
                #if DEBUG
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingDebugConsole = true
                    } label: {
                        Image(systemName: "ladybug")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(AppColors.textPrimary)
                    }
                    .accessibilityLabel("Debug console")
                }
                #endif
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingChartsSheet = true
                    } label: {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(AppColors.textPrimary)
                    }
                    .accessibilityLabel(String(localized: "View spending charts"))
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
            .alert(String(localized: "Delete Subscription"), isPresented: $showingDeleteAlert) {
                Button(String(localized: "Cancel"), role: .cancel) {
                    subscriptionToDelete = nil
                }
                Button(String(localized: "Delete"), role: .destructive) {
                    if let sub = subscriptionToDelete {
                        withAnimation {
                            store.deleteSubscription(id: sub.id)
                        }
                    }
                    subscriptionToDelete = nil
                }
            } message: {
                if let sub = subscriptionToDelete {
                    Text(String(localized: "Are you sure you want to delete \(sub.name)?"))
                }
            }
            #if DEBUG
            .sheet(isPresented: $showingDebugConsole) {
                DebugConsoleView(subscriptions: store.subscriptions)
            }
            #endif
            .sheet(isPresented: $showingChartsSheet) {
                ChartsView(subscriptions: store.subscriptions)
            }
            .onChange(of: store.saveError) { _, newValue in
                showingSaveErrorAlert = newValue != nil
            }
            .alert(String(localized: "Save Error"), isPresented: $showingSaveErrorAlert) {
                Button(String(localized: "OK"), role: .cancel) {
                    store.dismissSaveError()
                }
            } message: {
                if let error = store.saveError {
                    Text(error)
                }
            }
            .onChange(of: store.recentlyModifiedId) { _, newValue in
                if newValue != nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        store.clearRecentlyModified()
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView(store: SubscriptionStore())
}
