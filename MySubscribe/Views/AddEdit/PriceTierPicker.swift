//
//  PriceTierPicker.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 26.01.2026.
//

import SwiftUI

struct PriceTierPicker: View {
    let service: PopularSubscription
    @Binding var selectedTier: PriceTier?
    @Binding var customPrice: String
    @Binding var billingCycle: Subscription.BillingCycle
    
    @State private var useCustomPrice = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: service.iconName)
                    .font(.title2)
                    .foregroundStyle(service.category.color)
                    .frame(width: 44, height: 44)
                    .background(service.category.color.opacity(0.15))
                    .clipShape(.rect(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(service.name)
                        .font(.headline)
                        .foregroundStyle(AppColors.textPrimary)
                    
                    Text(String(localized: "Select your plan"))
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                ForEach(Array(service.priceTiers.enumerated()), id: \.element.id) { index, tier in
                    TierRow(
                        tier: tier,
                        isSelected: !useCustomPrice && selectedTier?.id == tier.id
                    ) {
                        useCustomPrice = false
                        selectedTier = tier
                        billingCycle = tier.billingCycle
                        customPrice = ""
                    }
                    
                    if index < service.priceTiers.count - 1 {
                        Divider()
                            .padding(.leading, 56)
                    }
                }
                
                Divider()
                    .padding(.leading, 56)
                
                customPriceRow
            }
            .background(AppColors.secondaryBackground)
            .clipShape(.rect(cornerRadius: 20))
            .padding(.horizontal, 20)
        }
    }
    
    private var customPriceRow: some View {
        Button {
            useCustomPrice = true
            selectedTier = nil
        } label: {
            HStack(spacing: 12) {
                Image(systemName: useCustomPrice ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(useCustomPrice ? service.category.color : AppColors.textSecondary)
                    .frame(width: 24)
                
                Text(String(localized: "Custom price"))
                    .font(.body)
                    .foregroundStyle(AppColors.textPrimary)
                
                Spacer()
                
                if useCustomPrice {
                    TextField("0.00", text: $customPrice)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                        .foregroundStyle(AppColors.textPrimary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct TierRow: View {
    let tier: PriceTier
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? Color(hex: "097CE0") : AppColors.textSecondary)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(tier.name)
                        .font(.body)
                        .foregroundStyle(AppColors.textPrimary)
                    
                    Text(tier.billingCycle.rawValue)
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
                
                Spacer()
                
                Text(tier.displayPrice)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(AppColors.textPrimary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var selectedTier: PriceTier? = PopularSubscriptionsData.netflix.defaultTier
        @State private var customPrice = ""
        @State private var billingCycle: Subscription.BillingCycle = .monthly
        
        var body: some View {
            ScrollView {
                PriceTierPicker(
                    service: PopularSubscriptionsData.netflix,
                    selectedTier: $selectedTier,
                    customPrice: $customPrice,
                    billingCycle: $billingCycle
                )
                .padding(.vertical)
            }
            .background(AppColors.background)
        }
    }
    
    return PreviewWrapper()
}
