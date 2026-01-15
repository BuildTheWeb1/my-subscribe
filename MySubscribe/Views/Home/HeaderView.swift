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
        VStack(spacing: 8) {
            Text("Total Monthly")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(AppColors.textSecondary)
            
            Text(totalMonthly.formattedAsCurrency)
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.textPrimary)
            
            Text("~\(totalYearly.formattedAsCurrency)/year")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
        .background(Color(hex: "FEF3C7"))
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
