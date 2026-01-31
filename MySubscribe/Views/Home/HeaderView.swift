//
//  HeaderView.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 15.01.2026.
//

import SwiftUI

struct CurvedBottomShape: Shape {
    var cornerRadius: CGFloat = 24
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let curveDepth: CGFloat = 40
        let bottomInset: CGFloat = 30
        
        path.move(to: CGPoint(x: cornerRadius, y: 0))
        path.addLine(to: CGPoint(x: rect.width - cornerRadius, y: 0))
        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: cornerRadius),
            control: CGPoint(x: rect.width, y: 0)
        )
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - curveDepth - bottomInset))
        
        path.addCurve(
            to: CGPoint(x: rect.width / 2, y: rect.height),
            control1: CGPoint(x: rect.width, y: rect.height - bottomInset),
            control2: CGPoint(x: rect.width * 0.75, y: rect.height)
        )
        
        path.addCurve(
            to: CGPoint(x: 0, y: rect.height - curveDepth - bottomInset),
            control1: CGPoint(x: rect.width * 0.25, y: rect.height),
            control2: CGPoint(x: 0, y: rect.height - bottomInset)
        )
        
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        path.addQuadCurve(
            to: CGPoint(x: cornerRadius, y: 0),
            control: CGPoint(x: 0, y: 0)
        )
        
        path.closeSubpath()
        return path
    }
}

struct HeaderView: View {
    let totalMonthly: Decimal
    let totalYearly: Decimal
    let subscriptionCount: Int
    let onAddTapped: () -> Void
    let onChartsTapped: () -> Void
    
    private let lightImpact = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 8) {
                    Text(String(localized: "Total Monthly"))
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Color.white.opacity(0.8))
                    
                    Text(totalMonthly.formattedAsCurrency)
                        .font(.largeTitle.bold().width(.condensed))
                        .foregroundStyle(Color.white)
                    
                    Text(String(localized: "~\(totalYearly.formattedAsCurrency)/year"))
                        .font(.callout.weight(.medium))
                        .foregroundStyle(Color.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 40)
                .padding(.bottom, 60)
                .padding(.horizontal, 20)
                .background(AppColors.cardGradientBlue)
                .clipShape(CurvedBottomShape())
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
                
                Button {
                    lightImpact.impactOccurred()
                    onChartsTapped()
                } label: {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Color.white.opacity(0.9))
                        .padding(12)
                        .background(Color.white.opacity(0.15))
                        .clipShape(Circle())
                }
                .accessibilityLabel(String(localized: "View spending charts"))
                .padding(.top, 12)
                .padding(.trailing, 8)
            }
            
            Button {
                mediumImpact.impactOccurred()
                onAddTapped()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.categoryFitness)
                        .frame(width: 70, height: 70)
                        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(Color(hex: "272533"))
                }
            }
            .accessibilityLabel(String(localized: "Add subscription"))
            .offset(y: 40)
        }
    }
}

#Preview {
    VStack {
        HeaderView(
            totalMonthly: 196.76,
            totalYearly: 2361.12,
            subscriptionCount: 12,
            onAddTapped: {},
            onChartsTapped: {}
        )
        Spacer()
    }
    .background(Color.white)
}
