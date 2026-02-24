//
//  CalendarView.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 23.02.2026.
//

import SwiftUI

struct SelectedDateItem: Identifiable {
    let id = UUID()
    let date: Date
}

struct CalendarView: View {
    let subscriptions: [Subscription]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.calendar) private var calendar
    @Environment(\.currencyService) private var currencyService
    
    @State private var displayedMonth: Date = Date()
    @State private var selectedDate: Date?
    @State private var detailDate: SelectedDateItem?
    
    private var subscriptionsForSelectedDate: [Subscription] {
        guard let date = detailDate?.date else { return [] }
        return subscriptionsForDate(date)
    }
    
    private var renewalDates: [Date: [Subscription]] {
        var result: [Date: [Subscription]] = [:]
        for subscription in subscriptions {
            let renewalDate = calendar.startOfDay(for: subscription.nextRenewalDate)
            result[renewalDate, default: []].append(subscription)
        }
        return result
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    monthNavigationHeader
                    
                    MonthGridView(
                        month: displayedMonth,
                        renewalDates: renewalDates,
                        selectedDate: $selectedDate,
                        onDateSelected: { date in
                            selectedDate = date
                            let subs = subscriptionsForDate(date)
                            if !subs.isEmpty {
                                detailDate = SelectedDateItem(date: date)
                            }
                        }
                    )
                    
                    upcomingRenewalsSection
                }
                .padding()
            }
            .background(AppColors.background)
            .navigationTitle(String(localized: "Calendar"))
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
            .sheet(item: $detailDate) { item in
                DayDetailSheet(
                    date: item.date,
                    subscriptions: subscriptionsForDate(item.date)
                )
                .presentationDetents([.medium])
            }
        }
        .presentationCornerRadius(20)
        .presentationDragIndicator(.visible)
    }
    
    private var monthNavigationHeader: some View {
        HStack {
            Button {
                withAnimation {
                    displayedMonth = calendar.date(byAdding: .month, value: -1, to: displayedMonth) ?? displayedMonth
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppColors.textPrimary)
                    .frame(width: 44, height: 44)
            }
            
            Spacer()
            
            Text(displayedMonth, format: .dateTime.month(.wide).year())
                .font(.title2.bold())
                .foregroundStyle(AppColors.textPrimary)
            
            Spacer()
            
            Button {
                withAnimation {
                    displayedMonth = calendar.date(byAdding: .month, value: 1, to: displayedMonth) ?? displayedMonth
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppColors.textPrimary)
                    .frame(width: 44, height: 44)
            }
        }
    }
    
    private var upcomingRenewalsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(String(localized: "Upcoming Renewals"))
                .font(.headline)
                .foregroundStyle(AppColors.textPrimary)
            
            let upcoming = upcomingRenewals
            if upcoming.isEmpty {
                Text(String(localized: "No renewals in the next 30 days"))
                    .font(.subheadline)
                    .foregroundStyle(AppColors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                ForEach(upcoming, id: \.id) { subscription in
                    upcomingRenewalRow(subscription)
                }
            }
        }
        .padding()
        .background(AppColors.secondaryBackground)
        .clipShape(.rect(cornerRadius: 16))
    }
    
    private var upcomingRenewals: [Subscription] {
        let now = Date()
        let thirtyDaysFromNow = calendar.date(byAdding: .day, value: 30, to: now) ?? now
        
        return subscriptions
            .filter { $0.nextRenewalDate >= now && $0.nextRenewalDate <= thirtyDaysFromNow }
            .sorted { $0.nextRenewalDate < $1.nextRenewalDate }
    }
    
    private func upcomingRenewalRow(_ subscription: Subscription) -> some View {
        HStack {
            Circle()
                .fill(AppColors.categoryColor(for: subscription.category))
                .frame(width: 8, height: 8)
            
            Text(subscription.name)
                .font(.subheadline)
                .foregroundStyle(AppColors.textPrimary)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(subscription.nextRenewalDate, format: .dateTime.month(.abbreviated).day())
                    .font(.caption.weight(.medium))
                    .foregroundStyle(AppColors.textPrimary)
                
                Text(currencyService.format(subscription.monthlyAmount))
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func subscriptionsForDate(_ date: Date) -> [Subscription] {
        let dayStart = calendar.startOfDay(for: date)
        return renewalDates[dayStart] ?? []
    }
}

#Preview {
    CalendarView(subscriptions: Subscription.samples)
}
