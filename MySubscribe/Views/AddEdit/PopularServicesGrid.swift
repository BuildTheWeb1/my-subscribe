//
//  PopularServicesGrid.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 26.01.2026.
//

import SwiftUI

struct PopularServicesGrid: View {
    let services: [PopularSubscription]
    let onServiceSelected: (PopularSubscription) -> Void
    let onSeeAllTapped: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(String(localized: "Popular Services"))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppColors.textPrimary)
                
                Spacer()
                
                Button {
                    onSeeAllTapped()
                } label: {
                    HStack(spacing: 4) {
                        Text(String(localized: "See All"))
                            .font(.subheadline)
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.semibold))
                    }
                    .foregroundStyle(AppColors.cardGradientBlue)
                }
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(services) { service in
                        PopularServiceCard(service: service) {
                            onServiceSelected(service)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    PopularServicesGrid(
        services: PopularSubscriptionsData.featured,
        onServiceSelected: { _ in },
        onSeeAllTapped: {}
    )
    .padding(.vertical)
    .background(AppColors.background)
}
