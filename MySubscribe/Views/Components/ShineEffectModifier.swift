//
//  ShineEffectModifier.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 21.01.2026.
//

import SwiftUI

struct ShineEffectModifier: ViewModifier {
    let isActive: Bool
    @State private var shineOffset: CGFloat = -1.5
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if isActive {
                    GeometryReader { geometry in
                        LinearGradient(
                            colors: [
                                .clear,
                                .white.opacity(0.4),
                                .white.opacity(0.6),
                                .white.opacity(0.4),
                                .clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(width: geometry.size.width * 0.5)
                        .offset(x: shineOffset * geometry.size.width)
                        .blur(radius: 3)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .allowsHitTesting(false)
                }
            }
            .onChange(of: isActive) { _, newValue in
                if newValue {
                    shineOffset = -1.5
                    withAnimation(.easeInOut(duration: 0.8)) {
                        shineOffset = 1.5
                    }
                }
            }
            .onAppear {
                if isActive {
                    shineOffset = -1.5
                    withAnimation(.easeInOut(duration: 0.8)) {
                        shineOffset = 1.5
                    }
                }
            }
    }
}

extension View {
    func shineEffect(isActive: Bool) -> some View {
        modifier(ShineEffectModifier(isActive: isActive))
    }
}
