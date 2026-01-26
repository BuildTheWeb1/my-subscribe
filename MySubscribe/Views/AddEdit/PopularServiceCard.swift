//
//  PopularServiceCard.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 26.01.2026.
//

import SwiftUI

struct PopularServiceCard: View {
    let service: PopularSubscription
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: service.iconName)
                    .font(.title2)
                    .foregroundStyle(service.category.color)
                    .frame(width: 44, height: 44)
                    .background(service.category.color.opacity(0.15))
                    .clipShape(.rect(cornerRadius: 12))
                
                Text(service.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(AppColors.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(width: 80)
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .background(AppColors.secondaryBackground)
            .clipShape(.rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack {
        PopularServiceCard(service: PopularSubscriptionsData.netflix) {}
        PopularServiceCard(service: PopularSubscriptionsData.spotify) {}
        PopularServiceCard(service: PopularSubscriptionsData.disneyPlus) {}
    }
    .padding()
    .background(AppColors.background)
}
