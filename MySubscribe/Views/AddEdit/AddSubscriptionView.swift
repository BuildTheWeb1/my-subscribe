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
    @State private var selectedColorIndex: Int = 0
    
    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        (Decimal(string: costString) ?? 0) > 0
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Service Name", text: $name)
                        .textContentType(.organizationName)
                    
                    HStack {
                        Text("$")
                            .foregroundStyle(AppColors.textSecondary)
                        TextField("0.00", text: $costString)
                            .keyboardType(.decimalPad)
                    }
                } header: {
                    Text("Subscription Details")
                }
                
                Section {
                    Picker("Billing Cycle", selection: $billingCycle) {
                        ForEach(Subscription.BillingCycle.allCases) { cycle in
                            Text(cycle.rawValue).tag(cycle)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Billing")
                }
                
                Section {
                    Picker("Category", selection: $category) {
                        ForEach(SubscriptionCategory.allCases) { cat in
                            Label(cat.rawValue, systemImage: cat.systemIcon)
                                .tag(cat)
                        }
                    }
                } header: {
                    Text("Category")
                }
                
                Section {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 44))
                    ], spacing: 12) {
                        ForEach(Array(AppColors.presetColors.enumerated()), id: \.offset) { index, color in
                            Circle()
                                .fill(color)
                                .frame(width: 44, height: 44)
                                .overlay {
                                    if selectedColorIndex == index {
                                        Circle()
                                            .strokeBorder(AppColors.textPrimary, lineWidth: 2)
                                    }
                                }
                                .onTapGesture {
                                    selectedColorIndex = index
                                }
                        }
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("Color")
                }
            }
            .navigationTitle("Add Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveSubscription()
                    }
                    .fontWeight(.semibold)
                    .disabled(!isValid)
                }
            }
        }
    }
    
    private func saveSubscription() {
        guard let cost = Decimal(string: costString), cost > 0 else { return }
        
        let colorHex = AppColors.presetColors[selectedColorIndex].toHex()
        
        let subscription = Subscription(
            name: name.trimmingCharacters(in: .whitespaces),
            cost: cost,
            billingCycle: billingCycle,
            category: category,
            customColor: colorHex
        )
        
        store.addSubscription(subscription)
        dismiss()
    }
}

#Preview {
    AddSubscriptionView(store: SubscriptionStore())
}
