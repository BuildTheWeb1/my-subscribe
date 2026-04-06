//
//  StopSubscriptionSheet.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 06.04.2026.
//

import SwiftUI

struct StopSubscriptionSheet: View {
    let subscriptionName: String
    let onConfirm: (Date) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var endDate = Date()

    var body: some View {
        VStack(spacing: 24) {
            // Handle
            Capsule()
                .fill(Color(.tertiaryLabel))
                .frame(width: 36, height: 5)
                .padding(.top, 8)

            // Icon + title
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "F59E0B").opacity(0.15))
                        .frame(width: 72, height: 72)
                    Image(systemName: "stop.circle.fill")
                        .font(.system(size: 34))
                        .foregroundStyle(Color(hex: "F59E0B"))
                }

                Text(String(localized: "Stop Subscription?"))
                    .font(.title2.bold())
                    .foregroundStyle(AppColors.textPrimary)

                Text("\(subscriptionName) will be marked as cancelled. All history is preserved and you can reactivate it anytime.")
                    .font(.subheadline)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
            }

            // End date picker
            VStack(spacing: 0) {
                HStack {
                    Label(String(localized: "End Date"), systemImage: "calendar")
                        .font(.body)
                        .foregroundStyle(AppColors.textPrimary)
                    Spacer()
                    DatePicker(
                        "",
                        selection: $endDate,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                    .labelsHidden()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)

            Spacer()

            // Actions
            VStack(spacing: 12) {
                Button {
                    onConfirm(endDate)
                    dismiss()
                } label: {
                    Text(String(localized: "Stop Subscription"))
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "F59E0B"))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }

                Button {
                    dismiss()
                } label: {
                    Text(String(localized: "Cancel"))
                        .font(.headline)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.hidden)
    }
}

#Preview {
    StopSubscriptionSheet(subscriptionName: "Netflix") { _ in }
}
