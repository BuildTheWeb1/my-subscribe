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
    
    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        parseCost(costString) > 0
    }
    
    private func parseCost(_ string: String) -> Decimal {
        let normalized = string.replacingOccurrences(of: ",", with: ".")
        return Decimal(string: normalized) ?? 0
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
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
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    
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
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    
                    Spacer(minLength: 40)
                }
            }
            // .background(AppColors.lightPeach)
            .navigationTitle(String(localized: "Add Subscription"))
            .navigationBarTitleDisplayMode(.inline)
            // .toolbarBackground(AppColors.lightPeach, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
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
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(String(localized: "Save")) {
                        saveSubscription()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(isValid ? AppColors.textPrimary : AppColors.textSecondary)
                    .disabled(!isValid)
                }
            }
        }
        .presentationCornerRadius(20)
        .presentationDragIndicator(.visible)
    }
    
    private func saveSubscription() {
        let cost = parseCost(costString)
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
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
    }
}

#Preview {
    AddSubscriptionView(store: SubscriptionStore())
}
