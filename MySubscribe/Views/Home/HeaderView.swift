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
        let curveHeight: CGFloat = 30
        let bottomY = rect.height - curveHeight
        
        path.move(to: CGPoint(x: cornerRadius, y: 0))
        path.addLine(to: CGPoint(x: rect.width - cornerRadius, y: 0))
        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: cornerRadius),
            control: CGPoint(x: rect.width, y: 0)
        )
        
        path.addLine(to: CGPoint(x: rect.width, y: bottomY - cornerRadius))
        path.addQuadCurve(
            to: CGPoint(x: rect.width - cornerRadius, y: bottomY),
            control: CGPoint(x: rect.width, y: bottomY)
        )
        
        path.addQuadCurve(
            to: CGPoint(x: cornerRadius, y: bottomY),
            control: CGPoint(x: rect.width / 2, y: rect.height + 15)
        )
        
        path.addQuadCurve(
            to: CGPoint(x: 0, y: bottomY - cornerRadius),
            control: CGPoint(x: 0, y: bottomY)
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
    
    var body: some View {
        ZStack(alignment: .bottom) {
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
            .background(Color(hex: "272533"))
            .clipShape(CurvedBottomShape())
            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
            
            Button {
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                onAddTapped()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.categoryMusic)
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
        .padding(.bottom, 35)
    }
}

#Preview {
    VStack {
        HeaderView(
            totalMonthly: 196.76,
            totalYearly: 2361.12,
            subscriptionCount: 12,
            onAddTapped: {}
        )
        Spacer()
    }
    .background(Color.white)
}
