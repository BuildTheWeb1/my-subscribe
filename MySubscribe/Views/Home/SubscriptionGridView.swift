//
//  SubscriptionGridView.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 15.01.2026.
//

import SwiftUI

struct ScrollFadeModifier: ViewModifier {
    let index: Int
    @State private var isVisible = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1 : 0.9)
            .onAppear {
                if reduceMotion {
                    isVisible = true
                } else {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(Double(index) * 0.05)) {
                        isVisible = true
                    }
                }
            }
            .onDisappear {
                isVisible = false
            }
    }
}

struct SubscriptionGridView: View {
    let subscriptions: [Subscription]
    let totalMonthly: Decimal
    let loadError: String?
    let onTap: (Subscription) -> Void
    let onDelete: (UUID) -> Void
    let onRetry: () -> Void
    
    private let twoColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    private let threeColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    private var largeSubscriptions: [Subscription] {
        subscriptions.filter { cardSize(for: $0) == .large }
            .sorted { $0.monthlyAmount > $1.monthlyAmount }
    }
    
    private var mediumSubscriptions: [Subscription] {
        subscriptions.filter { cardSize(for: $0) == .medium }
            .sorted { $0.monthlyAmount > $1.monthlyAmount }
    }
    
    private var smallSubscriptions: [Subscription] {
        subscriptions.filter { cardSize(for: $0) == .small }
            .sorted { $0.monthlyAmount > $1.monthlyAmount }
    }
    
    var body: some View {
        if let error = loadError {
            errorStateView(message: error)
        } else if subscriptions.isEmpty {
            emptyStateView
        } else {
            VStack(spacing: 24) {
                if !largeSubscriptions.isEmpty {
                    gridSection(
                        subscriptions: largeSubscriptions,
                        columns: twoColumns,
                        size: .large,
                        height: 180,
                        rowSpacing: 16,
                        startIndex: 0
                    )
                }
                
                if !mediumSubscriptions.isEmpty {
                    gridSection(
                        subscriptions: mediumSubscriptions,
                        columns: twoColumns,
                        size: .medium,
                        height: 140,
                        rowSpacing: 16,
                        startIndex: largeSubscriptions.count
                    )
                }
                
                if !smallSubscriptions.isEmpty {
                    gridSection(
                        subscriptions: smallSubscriptions,
                        columns: threeColumns,
                        size: .small,
                        height: 110,
                        rowSpacing: 12,
                        startIndex: largeSubscriptions.count + mediumSubscriptions.count
                    )
                }
            }
        }
    }
    
    @ViewBuilder
    private func gridSection(
        subscriptions: [Subscription],
        columns: [GridItem],
        size: SubscriptionCardView.CardSize,
        height: CGFloat,
        rowSpacing: CGFloat,
        startIndex: Int
    ) -> some View {
        LazyVGrid(columns: columns, spacing: rowSpacing) {
            ForEach(Array(subscriptions.enumerated()), id: \.element.id) { index, subscription in
                cardButton(subscription, size: size, height: height)
                    .modifier(ScrollFadeModifier(index: startIndex + index))
            }
        }
    }
    
    private func cardSize(for subscription: Subscription) -> SubscriptionCardView.CardSize {
        let percentage = totalMonthly > 0
            ? Double(truncating: (subscription.monthlyAmount / totalMonthly * 100) as NSDecimalNumber)
            : 0
        
        if percentage >= 15 {
            return .large
        } else if percentage >= 6 {
            return .medium
        } else {
            return .small
        }
    }
    
    @ViewBuilder
    private func cardButton(_ subscription: Subscription, size: SubscriptionCardView.CardSize, height: CGFloat) -> some View {
        Button {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            onTap(subscription)
        } label: {
            SubscriptionCardView(
                subscription: subscription,
                totalMonthly: totalMonthly,
                size: size
            )
            .frame(height: height)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(String(localized: "\(subscription.name), \(subscription.monthlyAmount.formattedAsCurrency) per month"))
        .accessibilityHint(String(localized: "Double tap to view details"))
        .contextMenu {
            Button(role: .destructive) {
                onDelete(subscription.id)
            } label: {
                Label(String(localized: "Delete"), systemImage: "trash")
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "creditcard")
                .font(.largeTitle)
                .imageScale(.large)
                .foregroundStyle(AppColors.textSecondary.opacity(0.5))
            
            Text(String(localized: "No Subscriptions"))
                .font(.title2.bold())
                .foregroundStyle(AppColors.textPrimary)
            
            Text(String(localized: "Tap + to add your first subscription"))
                .font(.subheadline)
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 60)
    }
    
    private func errorStateView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .imageScale(.large)
                .foregroundStyle(AppColors.coral)
            
            Text(String(localized: "Something went wrong"))
                .font(.title2.bold())
                .foregroundStyle(AppColors.textPrimary)
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
            
            Button {
                onRetry()
            } label: {
                Text(String(localized: "Try Again"))
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(AppColors.coral)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .accessibilityLabel(String(localized: "Retry loading subscriptions"))
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 60)
        .padding(.horizontal, 32)
    }
}

#Preview {
    ScrollView {
        SubscriptionGridView(
            subscriptions: Subscription.samples,
            totalMonthly: 196.76,
            loadError: nil,
            onTap: { _ in },
            onDelete: { _ in },
            onRetry: {}
        )
        .padding()
    }
    .background(Color.white)
}
