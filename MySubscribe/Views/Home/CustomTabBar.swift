//
//  CustomTabBar.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 06.04.2026.
//

import SwiftUI

// MARK: - Notched Shape

private struct TabBarNotchShape: Shape {
    private let notchDepth: CGFloat = 38
    private let notchHalfWidth: CGFloat = 54
    private let topCornerRadius: CGFloat = 28

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let cx = w / 2

        // Top-left corner start
        path.move(to: CGPoint(x: topCornerRadius, y: 0))

        // Left flat top → curve smoothly down into the notch
        path.addLine(to: CGPoint(x: cx - notchHalfWidth, y: 0))
        path.addCurve(
            to: CGPoint(x: cx, y: notchDepth),
            control1: CGPoint(x: cx - notchHalfWidth + notchHalfWidth * 0.35, y: 0),
            control2: CGPoint(x: cx - notchHalfWidth * 0.4, y: notchDepth)
        )

        // Curve back up from bottom of notch → right flat top
        path.addCurve(
            to: CGPoint(x: cx + notchHalfWidth, y: 0),
            control1: CGPoint(x: cx + notchHalfWidth * 0.4, y: notchDepth),
            control2: CGPoint(x: cx + notchHalfWidth - notchHalfWidth * 0.35, y: 0)
        )

        // Right flat top
        path.addLine(to: CGPoint(x: w - topCornerRadius, y: 0))

        // Top-right corner
        path.addQuadCurve(
            to: CGPoint(x: w, y: topCornerRadius),
            control: CGPoint(x: w, y: 0)
        )

        // Right side → bottom-right → bottom-left → left side
        path.addLine(to: CGPoint(x: w, y: h))
        path.addLine(to: CGPoint(x: 0, y: h))
        path.addLine(to: CGPoint(x: 0, y: topCornerRadius))

        // Top-left corner
        path.addQuadCurve(
            to: CGPoint(x: topCornerRadius, y: 0),
            control: CGPoint(x: 0, y: 0)
        )

        path.closeSubpath()
        return path
    }
}

// MARK: - Tab Bar

struct CustomTabBar: View {
    let inactiveCount: Int
    let onInactiveTapped: () -> Void
    let onAddTapped: () -> Void
    let onSettingsTapped: () -> Void

    private let centerButtonSize: CGFloat = 72
    private let centerButtonElevation: CGFloat = 28
    private let barHeight: CGFloat = 80
    private let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
    private let lightImpact = UIImpactFeedbackGenerator(style: .light)

    private var bottomSafeArea: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .keyWindow?
            .safeAreaInsets.bottom ?? 0
    }

    var body: some View {
        let bottomPad = bottomSafeArea
        ZStack(alignment: .top) {
            // Background fills the entire area including the safe area zone below
            Color(.systemBackground)

            // Bar background with notch — extended to cover the safe area below
            TabBarNotchShape()
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.10), radius: 16, x: 0, y: -4)
                .frame(height: barHeight + bottomPad)
                .offset(y: centerButtonElevation)

            // Side buttons row — bottom-padded so labels sit above the home indicator
            HStack(spacing: 0) {
                // Left: Inactive subscriptions
                sideButton(
                    icon: "archivebox.fill",
                    label: String(localized: "Inactive"),
                    badge: inactiveCount,
                    disabled: inactiveCount == 0
                ) {
                    lightImpact.impactOccurred()
                    onInactiveTapped()
                }

                Spacer()

                // Right: Settings
                sideButton(
                    icon: "gearshape.fill",
                    label: String(localized: "Settings"),
                    badge: 0,
                    disabled: false
                ) {
                    lightImpact.impactOccurred()
                    onSettingsTapped()
                }
            }
            .padding(.horizontal, 36)
            .padding(.bottom, bottomPad)
            .frame(height: barHeight + bottomPad)
            .offset(y: centerButtonElevation)

            // Center elevated add button
            Button {
                mediumImpact.impactOccurred()
                onAddTapped()
            } label: {
                ZStack {
                    // White ring for visual separation from the notch
                    Circle()
                        .fill(Color(.systemBackground))
                        .frame(width: centerButtonSize + 10, height: centerButtonSize + 10)

                    Circle()
                        .fill(AppColors.cardGradientBlue)
                        .frame(width: centerButtonSize, height: centerButtonSize)
                        .shadow(color: Color(hex: "097CE0").opacity(0.5), radius: 16, x: 0, y: 6)

                    Image(systemName: "plus")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            .accessibilityLabel(String(localized: "Add subscription"))
        }
        .frame(height: barHeight + centerButtonElevation)
        .ignoresSafeArea(edges: .bottom)
    }

    @ViewBuilder
    private func sideButton(
        icon: String,
        label: String,
        badge: Int,
        disabled: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 5) {
                ZStack(alignment: .topTrailing) {
                    ZStack {
                        Circle()
                            .fill(Color(.secondarySystemBackground))
                            .frame(width: 46, height: 46)

                        Image(systemName: icon)
                            .font(.system(size: 19, weight: .medium))
                            .foregroundStyle(disabled ? Color(.tertiaryLabel) : Color(.label))
                    }

                    if badge > 0 {
                        Text("\(badge)")
                            .font(.caption2.bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(AppColors.coral)
                            .clipShape(Capsule())
                            .offset(x: 6, y: -4)
                    }
                }

                Text(label)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(disabled ? Color(.tertiaryLabel) : Color(.secondaryLabel))
            }
        }
        .disabled(disabled)
        .buttonStyle(.plain)
        .accessibilityLabel(disabled
            ? String(localized: "\(label), no items")
            : (badge > 0 ? String(localized: "\(label), \(badge) items") : label)
        )
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(
            inactiveCount: 3,
            onInactiveTapped: {},
            onAddTapped: {},
            onSettingsTapped: {}
        )
    }
    .background(Color(.systemGroupedBackground))
}
