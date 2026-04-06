//
//  InactiveSubscriptionsView.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 06.04.2026.
//

import SwiftUI

struct InactiveSubscriptionsView: View {
    var store: SubscriptionStore
    @Environment(\.dismiss) private var dismiss
    @Environment(\.currencyService) private var currencyService
    @State private var selectedSubscription: Subscription?
    @State private var subscriptionToDelete: Subscription?
    @State private var showingDeleteAlert = false

    private var cancelled: [Subscription] {
        store.cancelledSubscriptions.sorted {
            ($0.endDate ?? .distantPast) > ($1.endDate ?? .distantPast)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if cancelled.isEmpty {
                    emptyState
                } else {
                    list
                }
            }
            .navigationTitle(String(localized: "Inactive"))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(String(localized: "Done")) { dismiss() }
                        .fontWeight(.semibold)
                }
            }
            .sheet(item: $selectedSubscription) { sub in
                SubscriptionDetailView(store: store, subscription: sub)
            }
            .alert(String(localized: "Delete Subscription"), isPresented: $showingDeleteAlert) {
                Button(String(localized: "Cancel"), role: .cancel) { subscriptionToDelete = nil }
                Button(String(localized: "Delete"), role: .destructive) {
                    if let sub = subscriptionToDelete {
                        store.deleteSubscription(id: sub.id)
                    }
                    subscriptionToDelete = nil
                }
            } message: {
                if let sub = subscriptionToDelete {
                    Text(String(localized: "Permanently delete \(sub.name)? This cannot be undone."))
                }
            }
        }
    }

    // MARK: - List

    private var list: some View {
        List {
            ForEach(cancelled) { sub in
                Button {
                    selectedSubscription = sub
                } label: {
                    row(sub)
                }
                .buttonStyle(.plain)
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .listRowBackground(Color(.secondarySystemBackground).opacity(0.5))
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button {
                        withAnimation {
                            store.reactivateSubscription(id: sub.id)
                        }
                    } label: {
                        Label(String(localized: "Reactivate"), systemImage: "play.circle.fill")
                    }
                    .tint(AppColors.categoryFitness)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        subscriptionToDelete = sub
                        showingDeleteAlert = true
                    } label: {
                        Label(String(localized: "Delete"), systemImage: "trash")
                    }
                }
                .contextMenu {
                    Button {
                        withAnimation {
                            store.reactivateSubscription(id: sub.id)
                        }
                    } label: {
                        Label(String(localized: "Reactivate"), systemImage: "play.circle")
                    }
                    Button(role: .destructive) {
                        subscriptionToDelete = sub
                        showingDeleteAlert = true
                    } label: {
                        Label(String(localized: "Delete"), systemImage: "trash")
                    }
                }
            }

            Section {
                summaryFooter
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
        }
        .listStyle(.insetGrouped)
    }

    @ViewBuilder
    private func row(_ sub: Subscription) -> some View {
        let color: Color = {
            if let hex = sub.customColor { return Color(hex: hex) }
            return AppColors.categoryColor(for: sub.category)
        }()

        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.18))
                    .frame(width: 44, height: 44)
                Image(systemName: sub.category.systemIcon)
                    .font(.body.weight(.medium))
                    .foregroundStyle(color.opacity(0.6))
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(sub.name)
                    .font(.body.weight(.medium))
                    .strikethrough(true, color: AppColors.textSecondary)
                    .foregroundStyle(AppColors.textSecondary)

                if let endDate = sub.endDate {
                    Text(String(localized: "Cancelled \(endDate.formatted(date: .abbreviated, time: .omitted))"))
                        .font(.caption)
                        .foregroundStyle(Color(.tertiaryLabel))
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text(currencyService.format(sub.monthlyAmount))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppColors.textSecondary)
                Text(sub.billingCycle.displaySuffix)
                    .font(.caption)
                    .foregroundStyle(Color(.tertiaryLabel))
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            String(localized: "\(sub.name), cancelled\(sub.endDate.map { " on \($0.formatted(date: .abbreviated, time: .omitted))" } ?? ""). \(currencyService.format(sub.monthlyAmount)) per month.")
        )
    }

    // MARK: - Summary footer

    private var summaryFooter: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(String(localized: "\(cancelled.count) inactive subscription\(cancelled.count == 1 ? "" : "s")"))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppColors.textSecondary)
                Text(String(localized: "Swipe right on any row to reactivate"))
                    .font(.caption)
                    .foregroundStyle(Color(.tertiaryLabel))
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "archivebox")
                .font(.system(size: 52))
                .foregroundStyle(Color(.tertiaryLabel))

            Text(String(localized: "No Inactive Subscriptions"))
                .font(.title3.bold())
                .foregroundStyle(AppColors.textPrimary)

            Text(String(localized: "When you stop a subscription it will appear here."))
                .font(.subheadline)
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    InactiveSubscriptionsView(store: SubscriptionStore())
}
