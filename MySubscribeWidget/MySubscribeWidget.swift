//
//  MySubscribeWidget.swift
//  MySubscribeWidget
//
//  Created by WebSpace Developer on 24.02.2026.
//

import WidgetKit
import SwiftUI

// MARK: - Timeline Entry

struct SubscriptionEntry: TimelineEntry {
    let date: Date
    let data: WidgetSubscriptionData
}

// MARK: - Timeline Provider

struct SubscriptionProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> SubscriptionEntry {
        SubscriptionEntry(date: Date(), data: .placeholder)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SubscriptionEntry) -> Void) {
        let data = WidgetDataProvider.load()
        let entry = SubscriptionEntry(date: Date(), data: data)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SubscriptionEntry>) -> Void) {
        let data = WidgetDataProvider.load()
        let entry = SubscriptionEntry(date: Date(), data: data)
        
        // Refresh at midnight or when data changes
        let nextMidnight = Calendar.current.startOfDay(for: Date().addingTimeInterval(86400))
        let timeline = Timeline(entries: [entry], policy: .after(nextMidnight))
        completion(timeline)
    }
}

// MARK: - Widget Views

struct SmallWidgetView: View {
    let data: WidgetSubscriptionData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "creditcard.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(data.subscriptionCount)")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(formatCurrency(data.totalMonthly, code: data.currencyCode))
                .font(.title2.bold())
                .minimumScaleFactor(0.7)
                .lineLimit(1)
            
            Text("per month")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct MediumWidgetView: View {
    let data: WidgetSubscriptionData
    
    var body: some View {
        HStack(spacing: 16) {
            // Left side - Total
            VStack(alignment: .leading, spacing: 4) {
                Text("Monthly")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(formatCurrency(data.totalMonthly, code: data.currencyCode))
                    .font(.title2.bold())
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
                
                Text("\(data.subscriptionCount) subscriptions")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            // Right side - Upcoming
            VStack(alignment: .leading, spacing: 4) {
                Text("Upcoming")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                if data.upcomingRenewals.isEmpty {
                    Text("No renewals")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                } else {
                    ForEach(data.upcomingRenewals.prefix(2)) { renewal in
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color(hex: renewal.categoryColorHex))
                                .frame(width: 6, height: 6)
                            
                            Text(renewal.name)
                                .font(.caption2)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Text(renewal.renewalDate, format: .dateTime.month(.abbreviated).day())
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct LargeWidgetView: View {
    let data: WidgetSubscriptionData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Total Monthly")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(formatCurrency(data.totalMonthly, code: data.currencyCode))
                        .font(.title.bold())
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Yearly")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(formatCurrency(data.totalYearly, code: data.currencyCode))
                        .font(.callout.weight(.semibold))
                }
            }
            
            Divider()
            
            // Upcoming renewals
            Text("Upcoming Renewals")
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)
            
            if data.upcomingRenewals.isEmpty {
                Text("No upcoming renewals")
                    .font(.subheadline)
                    .foregroundStyle(.tertiary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                VStack(spacing: 8) {
                    ForEach(data.upcomingRenewals.prefix(4)) { renewal in
                        HStack(spacing: 10) {
                            Circle()
                                .fill(Color(hex: renewal.categoryColorHex))
                                .frame(width: 8, height: 8)
                            
                            Text(renewal.name)
                                .font(.subheadline)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Text(formatCurrency(renewal.amount, code: data.currencyCode))
                                .font(.caption.weight(.medium))
                            
                            Text(renewal.renewalDate, format: .dateTime.month(.abbreviated).day())
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .frame(width: 50, alignment: .trailing)
                        }
                    }
                }
            }
            
            Spacer(minLength: 0)
        }
    }
}

// MARK: - Main Widget Entry View

struct MySubscribeWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: SubscriptionProvider.Entry
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(data: entry.data)
        case .systemMedium:
            MediumWidgetView(data: entry.data)
        case .systemLarge:
            LargeWidgetView(data: entry.data)
        default:
            SmallWidgetView(data: entry.data)
        }
    }
}

// MARK: - Widget Configuration

struct MySubscribeWidget: Widget {
    let kind: String = "MySubscribeWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SubscriptionProvider()) { entry in
            MySubscribeWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .widgetURL(URL(string: "mysubscribe://home"))
        }
        .configurationDisplayName("Subscriptions")
        .description("Track your monthly spending and upcoming renewals.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Helpers

private func formatCurrency(_ amount: Decimal, code: String) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = code
    formatter.maximumFractionDigits = 2
    return formatter.string(from: amount as NSDecimalNumber) ?? "\(amount)"
}

// MARK: - Preview

#Preview(as: .systemSmall) {
    MySubscribeWidget()
} timeline: {
    SubscriptionEntry(date: .now, data: .placeholder)
}

#Preview(as: .systemMedium) {
    MySubscribeWidget()
} timeline: {
    SubscriptionEntry(date: .now, data: .placeholder)
}

#Preview(as: .systemLarge) {
    MySubscribeWidget()
} timeline: {
    SubscriptionEntry(date: .now, data: .placeholder)
}
