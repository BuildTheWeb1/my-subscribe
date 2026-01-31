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
    let recentlyModifiedId: UUID?
    let onTap: (Subscription) -> Void
    let onDelete: (UUID) -> Void
    let onRetry: () -> Void
    
    private let spacing: CGFloat = 12
    private let impactGenerator = UIImpactFeedbackGenerator(style: .light)
    
    private var sortedSubscriptions: [Subscription] {
        subscriptions.sorted { $0.monthlyAmount > $1.monthlyAmount }
    }
    
    private var masonryColumns: (left: [(Subscription, SubscriptionCardView.CardSize)], right: [(Subscription, SubscriptionCardView.CardSize)]) {
        var leftColumn: [(Subscription, SubscriptionCardView.CardSize)] = []
        var rightColumn: [(Subscription, SubscriptionCardView.CardSize)] = []
        var leftHeight: CGFloat = 0
        var rightHeight: CGFloat = 0
        
        for subscription in sortedSubscriptions {
            let size = cardSize(for: subscription)
            let height = cardHeight(for: size)
            
            if leftHeight <= rightHeight {
                leftColumn.append((subscription, size))
                leftHeight += height + spacing
            } else {
                rightColumn.append((subscription, size))
                rightHeight += height + spacing
            }
        }
        
        return (leftColumn, rightColumn)
    }
    
    var body: some View {
        if let error = loadError {
            errorStateView(message: error)
        } else if subscriptions.isEmpty {
            emptyStateView
        } else {
            let columns = masonryColumns
            HStack(alignment: .top, spacing: spacing) {
                VStack(spacing: spacing) {
                    ForEach(Array(columns.left.enumerated()), id: \.element.0.id) { index, item in
                        cardButton(item.0, size: item.1, height: cardHeight(for: item.1))
                            .modifier(ScrollFadeModifier(index: index))
                    }
                }
                
                VStack(spacing: spacing) {
                    ForEach(Array(columns.right.enumerated()), id: \.element.0.id) { index, item in
                        cardButton(item.0, size: item.1, height: cardHeight(for: item.1))
                            .modifier(ScrollFadeModifier(index: columns.left.count + index))
                    }
                }
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
    
    private func cardHeight(for size: SubscriptionCardView.CardSize) -> CGFloat {
        switch size {
        case .large: return 180
        case .medium: return 140
        case .small: return 110
        }
    }
    
    @ViewBuilder
    private func cardButton(_ subscription: Subscription, size: SubscriptionCardView.CardSize, height: CGFloat) -> some View {
        Button {
            impactGenerator.impactOccurred()
            onTap(subscription)
        } label: {
            SubscriptionCardView(
                subscription: subscription,
                totalMonthly: totalMonthly,
                size: size
            )
            .frame(height: height)
            .shineEffect(isActive: subscription.id == recentlyModifiedId)
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
            recentlyModifiedId: nil,
            onTap: { _ in },
            onDelete: { _ in },
            onRetry: {}
        )
        .padding()
    }
    .background(Color.white)
}
