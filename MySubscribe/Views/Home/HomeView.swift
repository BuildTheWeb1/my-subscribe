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
    @State private var showingSettingsSheet = false
    @State private var showingCalendarSheet = false
    @State private var showingInactiveSheet = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var scrollPosition: ScrollPosition = .init(idType: String.self)
    
    private var hasSubscriptions: Bool {
        !store.activeSubscriptions.isEmpty || !store.cancelledSubscriptions.isEmpty
    }

    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 0) {
                        Color.clear
                            .frame(height: 200)
                        
                        SubscriptionGridView(
                            subscriptions: store.activeSubscriptions,
                            cancelledSubscriptions: store.cancelledSubscriptions,
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
                            onReactivate: { id in
                                store.reactivateSubscription(id: id)
                            },
                            onRetry: {
                                store.retryLoad()
                            }
                        )
                        .padding(16)
                        .padding(.bottom, 130)
                        .animation(reduceMotion ? nil : .easeInOut(duration: 0.3), value: store.activeSubscriptions.count)
                    }
                }
                .scrollPosition($scrollPosition)
                .scrollIndicators(.hidden)
                
                VStack {
                    HeaderView(
                        totalMonthly: store.totalMonthlySpending,
                        totalYearly: store.totalYearlyProjection,
                        subscriptionCount: store.subscriptionCount,
                        onChartsTapped: {
                            showingChartsSheet = true
                        },
                        onCalendarTapped: {
                            showingCalendarSheet = true
                        }
                    )
                    .zIndex(1)

                    Spacer()
                        .allowsHitTesting(false)

                    CustomTabBar(
                        inactiveCount: store.cancelledSubscriptions.count,
                        onInactiveTapped: {
                            showingInactiveSheet = true
                        },
                        onAddTapped: {
                            showingAddSheet = true
                            AnalyticsService.shared.track(.addSheetOpened)
                        },
                        onSettingsTapped: {
                            showingSettingsSheet = true
                        }
                    )
                }
            }
            .background(AppColors.background)
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
            .sheet(isPresented: $showingChartsSheet) {
                ChartsView(subscriptions: store.activeSubscriptions)
            }
            .sheet(isPresented: $showingSettingsSheet) {
                SettingsView()
            }
            .sheet(isPresented: $showingCalendarSheet) {
                CalendarView(subscriptions: store.activeSubscriptions)
            }
            .sheet(isPresented: $showingInactiveSheet) {
                InactiveSubscriptionsView(store: store)
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
                    Task {
                        try? await Task.sleep(for: .seconds(1.5))
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
