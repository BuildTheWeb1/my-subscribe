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
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showSettingsButton = true
    @State private var scrollPosition: ScrollPosition = .init(idType: String.self)
    @State private var lastContentOffset: CGFloat = 0
    
    private let settingsImpact = UIImpactFeedbackGenerator(style: .light)
    
    private var hasSubscriptions: Bool {
        !store.subscriptions.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 0) {
                        Color.clear
                            .frame(height: 260)
                        
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
                        .padding(16)
                        .padding(.bottom, 100)
                        .animation(reduceMotion ? nil : .easeInOut(duration: 0.3), value: store.subscriptions.count)
                    }
                }
                .scrollPosition($scrollPosition)
                .scrollIndicators(.hidden)
                .onScrollGeometryChange(for: CGFloat.self) { geometry in
                    geometry.contentOffset.y
                } action: { oldValue, newValue in
                    handleScrollChange(oldOffset: oldValue, newOffset: newValue)
                }
                
                VStack {
                    HeaderView(
                        totalMonthly: store.totalMonthlySpending,
                        totalYearly: store.totalYearlyProjection,
                        subscriptionCount: store.subscriptionCount,
                        onAddTapped: {
                            showingAddSheet = true
                            AnalyticsService.shared.track(.addSheetOpened)
                        },
                        onChartsTapped: {
                            showingChartsSheet = true
                        },
                        onCalendarTapped: {
                            showingCalendarSheet = true
                        }
                    )
                    .padding(.horizontal, 16)
                    .zIndex(1)
                    
                    Spacer()
                        .allowsHitTesting(false)
                    
                    Button {
                        settingsImpact.impactOccurred()
                        showingSettingsSheet = true
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppColors.categoryFitness)
                                .frame(width: 70, height: 70)
                                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
                            
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundStyle(Color(hex: "272533"))
                        }
                    }
                    .accessibilityLabel(String(localized: "Settings"))
                    .padding(.bottom, 8)
                    .scaleEffect(showSettingsButton ? 1 : 0.6)
                    .opacity(showSettingsButton ? 1 : 0)
                    .offset(y: showSettingsButton ? 0 : 60)
                    .allowsHitTesting(showSettingsButton)
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
                ChartsView(subscriptions: store.subscriptions)
            }
            .sheet(isPresented: $showingSettingsSheet) {
                SettingsView()
            }
            .sheet(isPresented: $showingCalendarSheet) {
                CalendarView(subscriptions: store.subscriptions)
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
    
    private func handleScrollChange(oldOffset: CGFloat, newOffset: CGFloat) {
        guard hasSubscriptions else {
            if !showSettingsButton {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    showSettingsButton = true
                }
            }
            return
        }
        
        // contentOffset.y increases when scrolling DOWN
        // contentOffset.y decreases when scrolling UP
        let delta = newOffset - oldOffset
        let threshold: CGFloat = 10
        
        if delta > threshold && showSettingsButton {
            // Scrolling down - hide button
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                showSettingsButton = false
            }
        } else if delta < -threshold && !showSettingsButton {
            // Scrolling up - show button
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                showSettingsButton = true
            }
        }
    }
}

#Preview {
    HomeView(store: SubscriptionStore())
}
