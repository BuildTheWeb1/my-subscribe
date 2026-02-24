//
//  ChartsView.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 22.01.2026.
//

import SwiftUI
import Charts

struct CategorySpending: Identifiable {
    let id = UUID()
    let category: SubscriptionCategory
    let amount: Decimal
    let color: Color
}

struct ChartsView: View {
    let subscriptions: [Subscription]
    @Environment(\.dismiss) private var dismiss
    @State private var animatedValues: [SubscriptionCategory: Double] = [:]
    @Environment(\.currencyService) private var currencyService
    
    private var categorySpending: [CategorySpending] {
        var spending: [SubscriptionCategory: Decimal] = [:]
        
        for subscription in subscriptions {
            let monthly = subscription.monthlyAmount
            spending[subscription.category, default: 0] += monthly
        }
        
        return spending.map { category, amount in
            CategorySpending(
                category: category,
                amount: amount,
                color: AppColors.categoryColor(for: category)
            )
        }
        .sorted { $0.amount > $1.amount }
    }
    
    private var totalSpending: Decimal {
        categorySpending.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if categorySpending.isEmpty {
                        emptyStateView
                    } else {
                        chartSection
                        legendSection
                    }
                }
                .padding()
            }
            .background(AppColors.background)
            .navigationTitle(String(localized: "Spending by Category"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
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
        .onAppear {
            animateChart()
        }
    }
    
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(String(localized: "Monthly Breakdown"))
                .font(.headline)
                .foregroundStyle(AppColors.textPrimary)
            
            Chart(categorySpending) { item in
                BarMark(
                    x: .value("Amount", animatedValues[item.category] ?? 0),
                    y: .value("Category", item.category.rawValue)
                )
                .foregroundStyle(item.color)
                .clipShape(.rect(cornerRadius: 6))
            }
            .chartXAxis {
                AxisMarks(position: .bottom) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let amount = value.as(Double.self) {
                            Text(formatShortCurrency(Decimal(amount)))
                                .font(.caption)
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let category = value.as(String.self) {
                            Text(category)
                                .font(.caption)
                                .foregroundStyle(AppColors.textPrimary)
                        }
                    }
                }
            }
            .frame(height: CGFloat(categorySpending.count) * 50 + 40)
        }
        .padding()
        .background(AppColors.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var legendSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(String(localized: "Details"))
                .font(.headline)
                .foregroundStyle(AppColors.textPrimary)
            
            ForEach(categorySpending) { item in
                HStack {
                    Circle()
                        .fill(item.color)
                        .frame(width: 12, height: 12)
                    
                    Text(item.category.rawValue)
                        .font(.subheadline)
                        .foregroundStyle(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Text(currencyService.format(item.amount))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppColors.textPrimary)
                    
                    Text(percentageText(for: item.amount))
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)
                        .frame(width: 45, alignment: .trailing)
                }
            }
            
            Divider()
            
            HStack {
                Text(String(localized: "Total"))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppColors.textPrimary)
                
                Spacer()
                
                Text(currencyService.format(totalSpending))
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppColors.textPrimary)
                
                Text("/mo")
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
                    .frame(width: 45, alignment: .trailing)
            }
        }
        .padding()
        .background(AppColors.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.bar.xaxis")
                .font(.largeTitle)
                .foregroundStyle(AppColors.textSecondary.opacity(0.5))
            
            Text(String(localized: "No Data Yet"))
                .font(.title2.bold())
                .foregroundStyle(AppColors.textPrimary)
            
            Text(String(localized: "Add subscriptions to see your spending breakdown"))
                .font(.subheadline)
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
    
    private func percentageText(for amount: Decimal) -> String {
        guard totalSpending > 0 else { return "0%" }
        let amountDouble = Double(truncating: amount as NSDecimalNumber)
        let totalDouble = Double(truncating: totalSpending as NSDecimalNumber)
        let percentage = (amountDouble / totalDouble) * 100
        return "\(Int(percentage.rounded()))%"
    }
    
    private func animateChart() {
        for item in categorySpending {
            animatedValues[item.category] = 0
        }
        
        Task {
            try? await Task.sleep(for: .milliseconds(100))
            withAnimation(.easeOut(duration: 0.8)) {
                for item in categorySpending {
                    animatedValues[item.category] = Double(truncating: item.amount as NSDecimalNumber)
                }
            }
        }
    }
    
    private func formatShortCurrency(_ amount: Decimal) -> String {
        let convertedAmount = currencyService.convert(amount, to: currencyService.selectedCurrencyCode)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyService.selectedCurrencyCode
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        
        return formatter.string(from: convertedAmount as NSDecimalNumber) ?? "\(convertedAmount)"
    }
}

#Preview {
    ChartsView(subscriptions: Subscription.samples)
}
