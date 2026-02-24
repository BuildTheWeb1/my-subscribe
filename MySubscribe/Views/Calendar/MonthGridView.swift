//
//  MonthGridView.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 23.02.2026.
//

import SwiftUI

struct MonthGridView: View {
    let month: Date
    let renewalDates: [Date: [Subscription]]
    @Binding var selectedDate: Date?
    let onDateSelected: (Date) -> Void
    
    @Environment(\.calendar) private var calendar
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    
    private var weekdaySymbols: [String] {
        calendar.shortWeekdaySymbols
    }
    
    private var days: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month) else {
            return []
        }
        
        var days: [Date] = []
        var current = monthInterval.start
        
        while current < monthInterval.end {
            days.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current) ?? current
        }
        
        return days
    }
    
    private var firstWeekdayOffset: Int {
        guard let firstDay = days.first else { return 0 }
        let weekday = calendar.component(.weekday, from: firstDay)
        return (weekday - calendar.firstWeekday + 7) % 7
    }
    
    var body: some View {
        VStack(spacing: 8) {
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(AppColors.textSecondary)
                        .frame(height: 30)
                }
            }
            
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(0..<firstWeekdayOffset, id: \.self) { _ in
                    Color.clear
                        .frame(height: 44)
                }
                
                ForEach(days, id: \.self) { date in
                    DayCell(
                        date: date,
                        subscriptions: subscriptionsForDate(date),
                        isSelected: isSelected(date),
                        isToday: calendar.isDateInToday(date),
                        onTap: {
                            onDateSelected(date)
                        }
                    )
                }
            }
        }
        .padding()
        .background(AppColors.secondaryBackground)
        .clipShape(.rect(cornerRadius: 16))
    }
    
    private func subscriptionsForDate(_ date: Date) -> [Subscription] {
        let dayStart = calendar.startOfDay(for: date)
        return renewalDates[dayStart] ?? []
    }
    
    private func isSelected(_ date: Date) -> Bool {
        guard let selectedDate = selectedDate else { return false }
        return calendar.isDate(date, inSameDayAs: selectedDate)
    }
}

#Preview {
    MonthGridView(
        month: Date(),
        renewalDates: [:],
        selectedDate: .constant(nil),
        onDateSelected: { _ in }
    )
    .padding()
}
