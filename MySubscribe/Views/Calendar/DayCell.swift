//
//  DayCell.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 23.02.2026.
//

import SwiftUI

struct DayCell: View {
    let date: Date
    let subscriptions: [Subscription]
    let isSelected: Bool
    let isToday: Bool
    let onTap: () -> Void
    
    @Environment(\.calendar) private var calendar
    
    private var dayNumber: Int {
        calendar.component(.day, from: date)
    }
    
    private var hasRenewals: Bool {
        !subscriptions.isEmpty
    }
    
    private var dotColors: [Color] {
        Array(subscriptions.prefix(3).map { AppColors.categoryColor(for: $0.category) })
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text("\(dayNumber)")
                    .font(.body.weight(isToday ? .bold : .regular))
                    .foregroundStyle(textColor)
                
                HStack(spacing: 2) {
                    ForEach(Array(dotColors.enumerated()), id: \.offset) { _, color in
                        Circle()
                            .fill(color)
                            .frame(width: 5, height: 5)
                    }
                }
                .frame(height: 5)
                .opacity(hasRenewals ? 1 : 0)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(backgroundColor)
            .clipShape(.rect(cornerRadius: 8))
            .overlay {
                if isToday {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(AppColors.categoryFitness, lineWidth: 2)
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    private var textColor: Color {
        if isSelected {
            return .white
        }
        return AppColors.textPrimary
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return Color(hex: "4A90D9")
        }
        return Color.clear
    }
}

#Preview {
    HStack {
        DayCell(
            date: Date(),
            subscriptions: [],
            isSelected: false,
            isToday: true,
            onTap: {}
        )
        
        DayCell(
            date: Date(),
            subscriptions: Subscription.samples.prefix(2).map { $0 },
            isSelected: true,
            isToday: false,
            onTap: {}
        )
        
        DayCell(
            date: Date(),
            subscriptions: Subscription.samples.prefix(3).map { $0 },
            isSelected: false,
            isToday: false,
            onTap: {}
        )
    }
    .padding()
}
