//
//  HeaderView.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 15.01.2026.
//

import SwiftUI

struct HeaderView: View {
    let totalMonthly: Decimal
    let totalYearly: Decimal
    let subscriptionCount: Int
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("TOTAL / MONTH")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(AppColors.textSecondary)
                    .tracking(1)
                
                Text(totalMonthly.formattedAsCurrency)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.textPrimary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("YEARLY PROJECTION")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(AppColors.textSecondary)
                    .tracking(1)
                
                Text(totalYearly.formattedAsCurrency)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.coral)
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [AppColors.mint.opacity(0.5), AppColors.skyBlue.opacity(0.3)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    HeaderView(
        totalMonthly: 196.76,
        totalYearly: 2361.12,
        subscriptionCount: 12
    )
    .padding()
}
