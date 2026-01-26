//
//  AllServicesView.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 26.01.2026.
//

import SwiftUI

struct AllServicesView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedCategory: SubscriptionCategory?
    
    let onServiceSelected: (PopularSubscription) -> Void
    
    private var filteredServices: [PopularSubscription] {
        var services = PopularSubscriptionsData.all
        
        if let category = selectedCategory {
            services = services.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            services = services.filter { $0.name.localizedStandardContains(searchText) }
        }
        
        return services
    }
    
    private var groupedServices: [(SubscriptionCategory, [PopularSubscription])] {
        let grouped = Dictionary(grouping: filteredServices) { $0.category }
        return SubscriptionCategory.allCases
            .compactMap { category in
                guard let services = grouped[category], !services.isEmpty else { return nil }
                return (category, services)
            }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    categoryFilterSection
                    
                    if filteredServices.isEmpty {
                        emptyStateView
                    } else {
                        servicesListSection
                    }
                }
                .padding(.vertical, 16)
            }
            .scrollIndicators(.hidden)
            .background(AppColors.background)
            .navigationTitle(String(localized: "All Services"))
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: String(localized: "Search services"))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
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
        .presentationCornerRadius(20)
        .presentationDragIndicator(.visible)
    }
    
    private var categoryFilterSection: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                CategoryFilterChip(
                    title: String(localized: "All"),
                    isSelected: selectedCategory == nil
                ) {
                    selectedCategory = nil
                }
                
                ForEach(SubscriptionCategory.allCases) { category in
                    CategoryFilterChip(
                        title: category.rawValue,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .scrollIndicators(.hidden)
    }
    
    private var servicesListSection: some View {
        LazyVStack(spacing: 24, pinnedViews: []) {
            ForEach(groupedServices, id: \.0) { category, services in
                VStack(alignment: .leading, spacing: 12) {
                    Text(category.rawValue)
                        .font(.headline)
                        .foregroundStyle(AppColors.textPrimary)
                        .padding(.horizontal, 20)
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12)
                        ],
                        spacing: 12
                    ) {
                        ForEach(services) { service in
                            ServiceGridItem(service: service) {
                                onServiceSelected(service)
                                dismiss()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(AppColors.textSecondary.opacity(0.5))
            
            Text(String(localized: "No services found"))
                .font(.headline)
                .foregroundStyle(AppColors.textSecondary)
            
            Text(String(localized: "Try a different search term or category"))
                .font(.subheadline)
                .foregroundStyle(AppColors.textSecondary.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}

struct CategoryFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(isSelected ? .white : AppColors.textPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background {
                    if isSelected {
                        AppColors.cardGradientBlue
                    } else {
                        AppColors.secondaryBackground
                    }
                }
                .clipShape(.capsule)
        }
        .buttonStyle(.plain)
    }
}

struct ServiceGridItem: View {
    let service: PopularSubscription
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: service.iconName)
                    .font(.title2)
                    .foregroundStyle(service.category.color)
                    .frame(width: 48, height: 48)
                    .background(service.category.color.opacity(0.15))
                    .clipShape(.rect(cornerRadius: 12))
                
                Text(service.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(AppColors.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.8)
                
                Text(service.defaultTier.displayPrice)
                    .font(.caption2)
                    .foregroundStyle(AppColors.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .background(AppColors.secondaryBackground)
            .clipShape(.rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AllServicesView { service in
        print("Selected: \(service.name)")
    }
}
