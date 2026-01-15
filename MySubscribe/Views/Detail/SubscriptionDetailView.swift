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
    @State private var selectedColorIndex: Int
    @State private var isEditing = false
    @State private var showingDeleteAlert = false
    
    init(store: SubscriptionStore, subscription: Subscription) {
        self.store = store
        self.subscription = subscription
        _name = State(initialValue: subscription.name)
        _costString = State(initialValue: "\(subscription.cost)")
        _billingCycle = State(initialValue: subscription.billingCycle)
        _category = State(initialValue: subscription.category)
        
        let colorIndex = AppColors.presetColors.firstIndex { color in
            color.toHex() == subscription.customColor
        } ?? 0
        _selectedColorIndex = State(initialValue: colorIndex)
    }
    
    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        (Decimal(string: costString) ?? 0) > 0
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
                        .font(.system(size: 36))
                        .foregroundStyle(AppColors.textPrimary)
                }
                
                Text(subscription.name)
                    .font(.title.bold())
                    .foregroundStyle(AppColors.textPrimary)
                
                Text(subscription.monthlyAmount.formattedAsCurrency)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.textPrimary)
                
                Text("per month")
                    .font(.subheadline)
                    .foregroundStyle(AppColors.textSecondary)
            }
            .padding(.top, 32)
            
            VStack(spacing: 16) {
                detailRow(title: "Billing Cycle", value: subscription.billingCycle.rawValue)
                detailRow(title: "Category", value: subscription.category.rawValue)
                detailRow(title: "Yearly Cost", value: subscription.yearlyAmount.formattedAsCurrency)
                detailRow(title: "Added", value: subscription.createdAt.formatted(date: .abbreviated, time: .omitted))
            }
            .padding(20)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)
            
            Spacer()
            
            Button(role: .destructive) {
                showingDeleteAlert = true
            } label: {
                Label("Delete Subscription", systemImage: "trash")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .foregroundStyle(.red)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Done") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    isEditing = true
                }
            }
        }
        .alert("Delete Subscription", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                store.deleteSubscription(id: subscription.id)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete \(subscription.name)?")
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
                TextField("Service Name", text: $name)
                
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
        .navigationTitle("Edit")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    resetFields()
                    isEditing = false
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
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
    }
    
    private func saveChanges() {
        guard let cost = Decimal(string: costString), cost > 0 else { return }
        
        let colorHex = AppColors.presetColors[selectedColorIndex].toHex()
        
        let updated = Subscription(
            id: subscription.id,
            name: name.trimmingCharacters(in: .whitespaces),
            cost: cost,
            billingCycle: billingCycle,
            category: category,
            customColor: colorHex,
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
