//
//  SubscriptionGridView.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 15.01.2026.
//

import SwiftUI

struct SubscriptionGridView: View {
    let subscriptions: [Subscription]
    let totalMonthly: Decimal
    let onTap: (Subscription) -> Void
    let onDelete: (UUID) -> Void
    
    private var sortedSubscriptions: [Subscription] {
        subscriptions.sorted { $0.monthlyAmount > $1.monthlyAmount }
    }
    
    var body: some View {
        if subscriptions.isEmpty {
            emptyStateView
        } else {
            gridContent
        }
    }
    
    @ViewBuilder
    private var gridContent: some View {
        let items = sortedSubscriptions
        
        VStack(spacing: 12) {
            if items.count >= 1 {
                firstRow(items: items)
            }
            
            if items.count >= 4 {
                secondRow(items: items)
            }
            
            if items.count >= 7 {
                thirdRow(items: items)
            }
            
            if items.count >= 10 {
                remainingRows(items: Array(items.dropFirst(9)))
            }
        }
    }
    
    @ViewBuilder
    private func firstRow(items: [Subscription]) -> some View {
        HStack(spacing: 12) {
            if items.count >= 1 {
                cardButton(items[0], size: .large)
                    .frame(height: 220)
            }
            
            if items.count >= 2 {
                VStack(spacing: 12) {
                    cardButton(items[1], size: .medium)
                    
                    if items.count >= 3 {
                        cardButton(items[2], size: .medium)
                    }
                }
                .frame(height: 220)
            }
        }
    }
    
    @ViewBuilder
    private func secondRow(items: [Subscription]) -> some View {
        HStack(spacing: 12) {
            if items.count >= 4 {
                VStack(spacing: 12) {
                    cardButton(items[3], size: .medium)
                    
                    if items.count >= 6 {
                        cardButton(items[5], size: .medium)
                    }
                }
                .frame(height: 220)
            }
            
            if items.count >= 5 {
                VStack(spacing: 12) {
                    cardButton(items[4], size: .medium)
                    
                    HStack(spacing: 12) {
                        if items.count >= 7 {
                            cardButton(items[6], size: .small)
                        }
                        if items.count >= 8 {
                            cardButton(items[7], size: .small)
                        }
                    }
                }
                .frame(height: 220)
            }
        }
    }
    
    @ViewBuilder
    private func thirdRow(items: [Subscription]) -> some View {
        if items.count >= 9 {
            HStack(spacing: 12) {
                cardButton(items[8], size: .small)
                
                if items.count >= 10 {
                    cardButton(items[9], size: .small)
                }
                
                if items.count >= 11 {
                    cardButton(items[10], size: .small)
                }
                
                if items.count >= 12 {
                    cardButton(items[11], size: .small)
                }
            }
            .frame(height: 100)
        }
    }
    
    @ViewBuilder
    private func remainingRows(items: [Subscription]) -> some View {
        let columns = [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ]
        
        if items.count > 3 {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(Array(items.dropFirst(3))) { subscription in
                    cardButton(subscription, size: .small)
                        .frame(height: 100)
                }
            }
        }
    }
    
    @ViewBuilder
    private func cardButton(_ subscription: Subscription, size: SubscriptionCardView.CardSize) -> some View {
        Button {
            onTap(subscription)
        } label: {
            SubscriptionCardView(
                subscription: subscription,
                totalMonthly: totalMonthly,
                size: size
            )
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button(role: .destructive) {
                onDelete(subscription.id)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "creditcard")
                .font(.system(size: 60))
                .foregroundStyle(AppColors.textSecondary.opacity(0.5))
            
            Text("No Subscriptions")
                .font(.title2.bold())
                .foregroundStyle(AppColors.textPrimary)
            
            Text("Tap + to add your first subscription")
                .font(.subheadline)
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 60)
    }
}

#Preview {
    ScrollView {
        SubscriptionGridView(
            subscriptions: Subscription.samples,
            totalMonthly: 196.76,
            onTap: { _ in },
            onDelete: { _ in }
        )
        .padding()
    }
    .background(AppColors.background)
}
