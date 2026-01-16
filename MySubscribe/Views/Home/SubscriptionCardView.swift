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
            case .large: return .title.bold().width(.condensed)
            case .medium: return .title2.bold().width(.condensed)
            case .small: return .headline.bold().width(.condensed)
            }
        }
        
        var nameFont: Font {
            switch self {
            case .large: return .subheadline.weight(.medium)
            case .medium: return .footnote.weight(.medium)
            case .small: return .caption.weight(.medium)
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
        AppColors.categoryColor(for: subscription.category)
    }
    
    private var textColor: Color {
        AppColors.textColor(for: backgroundColor)
    }
    
    private var secondaryTextColor: Color {
        AppColors.secondaryTextColor(for: backgroundColor)
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
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.white.opacity(0.25))
                        .frame(width: size.iconSize, height: size.iconSize)
                    
                    Image(systemName: subscription.category.systemIcon)
                        .font(.system(size: size.iconSize * 0.5))
                        .foregroundStyle(textColor)
                }
                
                Spacer()
                
                if size != .small && percentageOfTotal > 0 {
                    Text("\(percentageOfTotal)%")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(textColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.25))
                        .clipShape(Capsule())
                }
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(subscription.name)
                    .font(size.nameFont)
                    .foregroundStyle(textColor)
                    .lineLimit(1)
                
                Text(subscription.monthlyAmount.formattedAsShortCurrency)
                    .font(size.priceFont)
                    .foregroundStyle(textColor)
                
                Text("~\(subscription.yearlyAmount.formattedAsShortCurrency)/yr")
                    .font(size == .small ? .caption2 : .caption)
                    .foregroundStyle(secondaryTextColor)
            }
        }
        .padding(size.padding)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 20))
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
