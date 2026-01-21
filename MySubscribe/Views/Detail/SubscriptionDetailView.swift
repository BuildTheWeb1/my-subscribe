//
//  SubscriptionDetailView.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 15.01.2026.
//

import SwiftUI

struct SubscriptionDetailView: View {
    var store: SubscriptionStore
    @Environment(\.dismiss) private var dismiss
    
    let subscription: Subscription
    
    @State private var name: String
    @State private var costString: String
    @State private var billingCycle: Subscription.BillingCycle
    @State private var category: SubscriptionCategory
    @State private var startDate: Date
    @State private var isEditing = false
    @State private var showingDeleteAlert = false
    
    init(store: SubscriptionStore, subscription: Subscription) {
        self.store = store
        self.subscription = subscription
        _name = State(initialValue: subscription.name)
        _costString = State(initialValue: "\(subscription.cost)")
        _billingCycle = State(initialValue: subscription.billingCycle)
        _category = State(initialValue: subscription.category)
        _startDate = State(initialValue: subscription.startDate)
    }
    
    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        parseCost(costString) > 0
    }
    
    private func parseCost(_ string: String) -> Decimal {
        let normalized = string.replacingOccurrences(of: ",", with: ".")
        return Decimal(string: normalized) ?? 0
    }
    
    private var backgroundColor: Color {
        if let hex = subscription.customColor {
            return Color(hex: hex)
        }
        return AppColors.categoryColor(for: subscription.category)
    }
    
    var body: some View {
        NavigationStack {
            if isEditing {
                editForm
            } else {
                detailView
            }
        }
    }
    
    private var detailView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(backgroundColor)
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: subscription.category.systemIcon)
                        .font(.title)
                        .foregroundStyle(AppColors.textColor(for: backgroundColor))
                }
                
                Text(subscription.name)
                    .font(.title.bold())
                    .foregroundStyle(AppColors.textPrimary)
                
                Text(subscription.monthlyAmount.formattedAsCurrency)
                    .font(.largeTitle.bold())
                    .foregroundStyle(AppColors.textPrimary)
                
                Text(String(localized: "per month"))
                    .font(.subheadline)
                    .foregroundStyle(AppColors.textSecondary)
            }
            .padding(.top, 32)
            
            VStack(spacing: 16) {
                detailRow(title: String(localized: "Billing Cycle"), value: subscription.billingCycle.rawValue)
                detailRow(title: String(localized: "Category"), value: subscription.category.rawValue)
                detailRow(title: String(localized: "Yearly Cost"), value: subscription.yearlyAmount.formattedAsCurrency)
                detailRow(title: String(localized: "Paid So Far"), value: subscription.paidSoFar.formattedAsCurrency)
                detailRow(title: String(localized: "Started"), value: subscription.startDate.formatted(date: .abbreviated, time: .omitted))
            }
            .padding(20)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)
            
            Spacer()
            
            Button(role: .destructive) {
                showingDeleteAlert = true
            } label: {
                Label(String(localized: "Delete Subscription"), systemImage: "trash")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "F53722"))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .navigationTitle(String(localized: "Details"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(String(localized: "Done")) {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: "Edit")) {
                    isEditing = true
                }
            }
        }
        .alert(String(localized: "Delete Subscription"), isPresented: $showingDeleteAlert) {
            Button(String(localized: "Cancel"), role: .cancel) { }
            Button(String(localized: "Delete"), role: .destructive) {
                store.deleteSubscription(id: subscription.id)
                dismiss()
            }
        } message: {
            Text(String(localized: "Are you sure you want to delete \(subscription.name)?"))
        }
    }
    
    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(AppColors.textSecondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
                .foregroundStyle(AppColors.textPrimary)
        }
    }
    
    private var editForm: some View {
        Form {
            Section {
                TextField(String(localized: "Service Name"), text: $name)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                
                HStack {
                    Text("$")
                        .foregroundStyle(AppColors.textSecondary)
                    TextField("0.00", text: $costString)
                        .keyboardType(.decimalPad)
                        .autocorrectionDisabled()
                }
            } header: {
                Text(String(localized: "Subscription Details"))
            }
            
            Section {
                Picker("Billing Cycle", selection: $billingCycle) {
                    ForEach(Subscription.BillingCycle.allCases) { cycle in
                        Text(cycle.rawValue).tag(cycle)
                    }
                }
                .pickerStyle(.segmented)
            } header: {
                Text(String(localized: "Billing"))
            }
            
            Section {
                Picker(String(localized: "Category"), selection: $category) {
                    ForEach(SubscriptionCategory.allCases) { cat in
                        Label(cat.rawValue, systemImage: cat.systemIcon)
                            .tag(cat)
                    }
                }
            } header: {
                Text(String(localized: "Category"))
            }
            
            Section {
                DatePicker(String(localized: "Start Date"), selection: $startDate, displayedComponents: .date)
            } header: {
                Text(String(localized: "Start Date"))
            }
        }
        .navigationTitle(String(localized: "Edit"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    resetFields()
                    isEditing = false
                } label: {
                    Image(systemName: "xmark")
                        .font(.body.weight(.medium))
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: "Save")) {
                    saveChanges()
                }
                .fontWeight(.semibold)
                .disabled(!isValid)
            }
        }
    }
    
    private func resetFields() {
        name = subscription.name
        costString = "\(subscription.cost)"
        billingCycle = subscription.billingCycle
        category = subscription.category
        startDate = subscription.startDate
    }
    
    private func saveChanges() {
        let cost = parseCost(costString)
        guard cost > 0 else { return }
        
        let updated = Subscription(
            id: subscription.id,
            name: name.trimmingCharacters(in: .whitespaces),
            cost: cost,
            billingCycle: billingCycle,
            category: category,
            startDate: startDate,
            createdAt: subscription.createdAt,
            updatedAt: Date()
        )
        
        store.updateSubscription(updated)
        isEditing = false
        dismiss()
    }
}

#Preview {
    SubscriptionDetailView(
        store: SubscriptionStore(),
        subscription: Subscription.samples[0]
    )
}
