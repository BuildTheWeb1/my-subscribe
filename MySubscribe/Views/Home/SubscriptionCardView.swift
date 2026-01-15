//
//  SubscriptionCardView.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 15.01.2026.
//

import SwiftUI

struct SubscriptionCardView: View {
    let subscription: Subscription
    let totalMonthly: Decimal
    let size: CardSize
    
    enum CardSize {
        case large
        case medium
        case small
        
        var iconSize: CGFloat {
            switch self {
            case .large: return 44
            case .medium: return 36
            case .small: return 28
            }
        }
        
        var priceFont: Font {
            switch self {
            case .large: return .system(size: 36, weight: .bold, design: .rounded)
            case .medium: return .system(size: 24, weight: .bold, design: .rounded)
            case .small: return .system(size: 18, weight: .bold, design: .rounded)
            }
        }
        
        var nameFont: Font {
            switch self {
            case .large: return .system(size: 16, weight: .medium)
            case .medium: return .system(size: 14, weight: .medium)
            case .small: return .system(size: 12, weight: .medium)
            }
        }
        
        var padding: CGFloat {
            switch self {
            case .large: return 16
            case .medium: return 14
            case .small: return 10
            }
        }
    }
    
    private var backgroundColor: Color {
        if let hex = subscription.customColor {
            return Color(hex: hex)
        }
        return AppColors.categoryColor(for: subscription.category)
    }
    
    private var percentageOfTotal: Int {
        guard totalMonthly > 0 else { return 0 }
        let percentage = (subscription.monthlyAmount / totalMonthly) * 100
        return Int(truncating: percentage as NSDecimalNumber)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.8))
                        .frame(width: size.iconSize, height: size.iconSize)
                    
                    Image(systemName: subscription.category.systemIcon)
                        .font(.system(size: size.iconSize * 0.5))
                        .foregroundStyle(AppColors.textPrimary)
                }
                
                Spacer()
                
                if size != .small && percentageOfTotal > 0 {
                    Text("\(percentageOfTotal)%")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(AppColors.textSecondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.6))
                        .clipShape(Capsule())
                }
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(subscription.name)
                    .font(size.nameFont)
                    .foregroundStyle(AppColors.textPrimary)
                    .lineLimit(1)
                
                Text(subscription.monthlyAmount.formattedAsShortCurrency)
                    .font(size.priceFont)
                    .foregroundStyle(AppColors.textPrimary)
                
                Text("~\(subscription.yearlyAmount.formattedAsShortCurrency)/yr")
                    .font(.system(size: size == .small ? 10 : 12))
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
        .padding(size.padding)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    HStack(spacing: 12) {
        SubscriptionCardView(
            subscription: Subscription.samples[0],
            totalMonthly: 200,
            size: .medium
        )
        .frame(height: 160)
        
        SubscriptionCardView(
            subscription: Subscription.samples[1],
            totalMonthly: 200,
            size: .small
        )
        .frame(height: 100)
    }
    .padding()
}
