//
//  DayDetailSheet.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 23.02.2026.
//

import SwiftUI

struct DayDetailSheet: View {
    let date: Date
    let subscriptions: [Subscription]
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.currencyService) private var currencyService
    
    private var totalForDay: Decimal {
        subscriptions.reduce(Decimal.zero) { $0 + $1.monthlyAmount }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(subscriptions) { subscription in
                        subscriptionRow(subscription)
                    }
                } header: {
                    Text(String(localized: "Renewals"))
                } footer: {
                    if subscriptions.count > 1 {
                        HStack {
                            Text(String(localized: "Total"))
                                .font(.subheadline.weight(.semibold))
                            Spacer()
                            Text(currencyService.format(totalForDay))
                                .font(.subheadline.weight(.semibold))
                        }
                        .padding(.top, 8)
                    }
                }
            }
            .navigationTitle(date.formatted(date: .long, time: .omitted))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.body.weight(.medium))
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
            }
        }
    }
    
    private func subscriptionRow(_ subscription: Subscription) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(AppColors.categoryColor(for: subscription.category))
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(subscription.name)
                    .font(.body.weight(.medium))
                    .foregroundStyle(AppColors.textPrimary)
                
                Text(subscription.category.rawValue)
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(currencyService.format(subscription.cost))
                    .font(.body.weight(.semibold))
                    .foregroundStyle(AppColors.textPrimary)
                
                Text(subscription.billingCycle.displaySuffix)
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    DayDetailSheet(
        date: Date(),
        subscriptions: Array(Subscription.samples.prefix(3))
    )
}
