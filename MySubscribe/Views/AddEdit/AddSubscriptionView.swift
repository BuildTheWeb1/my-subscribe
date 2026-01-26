//
//  AddSubscriptionView.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 15.01.2026.
//

import SwiftUI

struct AddSubscriptionView: View {
    var store: SubscriptionStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var costString = ""
    @State private var billingCycle: Subscription.BillingCycle = .monthly
    @State private var category: SubscriptionCategory = .other
    @State private var startDate = Date()
    
    @State private var selectedService: PopularSubscription?
    @State private var selectedTier: PriceTier?
    @State private var showingAllServices = false
    
    private var isValid: Bool {
        let hasName = !name.trimmingCharacters(in: .whitespaces).isEmpty
        let hasPrice = selectedTier != nil || parseCost(costString) > 0
        return hasName && hasPrice
    }
    
    private func parseCost(_ string: String) -> Decimal {
        let normalized = string.replacingOccurrences(of: ",", with: ".")
        return Decimal(string: normalized) ?? 0
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    if selectedService == nil {
                        popularServicesSection
                        
                        manualEntryDivider
                    }
                    
                    if let service = selectedService {
                        selectedServiceHeader(service)
                        
                        PriceTierPicker(
                            service: service,
                            selectedTier: $selectedTier,
                            customPrice: $costString,
                            billingCycle: $billingCycle
                        )
                        .padding(.top, 16)
                        
                        additionalOptionsSection
                    } else {
                        manualEntrySection
                    }
                    
                    Spacer(minLength: 40)
                }
            }
            .scrollIndicators(.hidden)
            .background(AppColors.background)
            .navigationTitle(String(localized: "Add Subscription"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        if selectedService != nil {
                            clearSelection()
                        } else {
                            dismiss()
                        }
                    } label: {
                        Image(systemName: selectedService != nil ? "chevron.left" : "xmark")
                            .font(.body.weight(.medium))
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(String(localized: "Save")) {
                        saveSubscription()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(isValid ? AppColors.textPrimary : AppColors.textSecondary)
                    .disabled(!isValid)
                }
            }
            .sheet(isPresented: $showingAllServices) {
                AllServicesView { service in
                    selectService(service)
                }
            }
        }
        .presentationCornerRadius(20)
        .presentationDragIndicator(.visible)
    }
    
    // MARK: - Sections
    
    private var popularServicesSection: some View {
        PopularServicesGrid(
            services: PopularSubscriptionsData.featured,
            onServiceSelected: { service in
                selectService(service)
            },
            onSeeAllTapped: {
                showingAllServices = true
            }
        )
        .padding(.top, 24)
    }
    
    private var manualEntryDivider: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(AppColors.textSecondary.opacity(0.3))
                .frame(height: 1)
            
            Text(String(localized: "or add manually"))
                .font(.caption)
                .foregroundStyle(AppColors.textSecondary)
            
            Rectangle()
                .fill(AppColors.textSecondary.opacity(0.3))
                .frame(height: 1)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
    }
    
    private func selectedServiceHeader(_ service: PopularSubscription) -> some View {
        HStack {
            Button {
                clearSelection()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: service.iconName)
                        .font(.title3)
                        .foregroundStyle(service.category.color)
                        .frame(width: 36, height: 36)
                        .background(service.category.color.opacity(0.15))
                        .clipShape(.rect(cornerRadius: 10))
                    
                    Text(service.name)
                        .font(.headline)
                        .foregroundStyle(AppColors.textPrimary)
                    
                    Image(systemName: "xmark.circle.fill")
                        .font(.body)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            .buttonStyle(.plain)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
    }
    
    private var additionalOptionsSection: some View {
        VStack(spacing: 0) {
            InputRow(icon: "calendar", title: String(localized: "Start Date")) {
                DatePicker("", selection: $startDate, displayedComponents: .date)
                    .labelsHidden()
            }
        }
        .background(AppColors.secondaryBackground)
        .clipShape(.rect(cornerRadius: 20))
        .padding(.horizontal, 20)
        .padding(.top, 24)
    }
    
    private var manualEntrySection: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                InputRow(icon: "tag.fill", title: String(localized: "Service")) {
                    TextField(String(localized: "Enter name"), text: $name)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                }
                
                Divider()
                    .padding(.leading, 40)
                    .padding(.trailing, 40)
                
                InputRow(icon: "dollarsign.circle.fill", title: String(localized: "Amount")) {
                    TextField("0.00", text: $costString)
                        .keyboardType(.decimalPad)
                        .autocorrectionDisabled()
                }
            }
            .background(AppColors.secondaryBackground)
            .clipShape(.rect(cornerRadius: 20))
            .padding(.horizontal, 20)
            
            Text(String(localized: "Billing"))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppColors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 12)
            
            Picker("", selection: $billingCycle) {
                ForEach(Subscription.BillingCycle.allCases) { cycle in
                    Text(cycle.rawValue).tag(cycle)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                InputRow(icon: category.systemIcon, title: String(localized: "Category")) {
                    Picker("", selection: $category) {
                        ForEach(SubscriptionCategory.allCases) { cat in
                            Label(cat.rawValue, systemImage: cat.systemIcon).tag(cat)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(AppColors.textSecondary)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                }
                
                Divider()
                    .padding(.leading, 40)
                    .padding(.trailing, 40)
                
                InputRow(icon: "calendar", title: String(localized: "Start Date")) {
                    DatePicker("", selection: $startDate, displayedComponents: .date)
                        .labelsHidden()
                }
            }
            .background(AppColors.secondaryBackground)
            .clipShape(.rect(cornerRadius: 20))
            .padding(.horizontal, 20)
            .padding(.top, 24)
        }
    }
    
    // MARK: - Actions
    
    private func selectService(_ service: PopularSubscription) {
        selectedService = service
        name = service.name
        category = service.category
        selectedTier = service.defaultTier
        billingCycle = service.defaultTier.billingCycle
        costString = ""
    }
    
    private func clearSelection() {
        selectedService = nil
        selectedTier = nil
        name = ""
        costString = ""
        category = .other
        billingCycle = .monthly
    }
    
    private func saveSubscription() {
        var cost: Decimal
        
        if let tier = selectedTier {
            cost = tier.price
        } else {
            cost = parseCost(costString)
        }
        
        guard cost > 0 else { return }
        
        let subscription = Subscription(
            name: name.trimmingCharacters(in: .whitespaces),
            cost: cost,
            billingCycle: billingCycle,
            category: category,
            startDate: startDate
        )
        
        store.addSubscription(subscription)
        dismiss()
    }
}

struct InputRow<Content: View>: View {
    let icon: String
    let title: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(AppColors.textSecondary)
                .frame(width: 24)
            
            Text(title)
                .font(.body)
                .foregroundStyle(AppColors.textPrimary)
            
            Spacer()
            
            content()
                .frame(minWidth: 120, alignment: .trailing)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .contentShape(Rectangle())
    }
}

#Preview {
    AddSubscriptionView(store: SubscriptionStore())
}
