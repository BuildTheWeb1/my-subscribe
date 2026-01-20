//
//  SplashScreenView.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 20.01.2026.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var rotation: Double = 0
    @State private var showSpark: Bool = false
    @State private var sparkOpacity: Double = 0
    @State private var sparkScale: Double = 0.5
    @Binding var isActive: Bool
    
    var body: some View {
        ZStack {
            AppColors.cardGradientBlue
                .ignoresSafeArea()
            
            ZStack {
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(rotation))
                
                if showSpark {
                    SparkView()
                        .opacity(sparkOpacity)
                        .scaleEffect(sparkScale)
                }
            }
        }
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        withAnimation(.easeInOut(duration: 0.6)) {
            rotation = 360
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            showSpark = true
            withAnimation(.easeOut(duration: 0.15)) {
                sparkOpacity = 1
                sparkScale = 1.2
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.easeIn(duration: 0.1)) {
                    sparkOpacity = 0
                    sparkScale = 1.5
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isActive = false
                }
            }
        }
    }
}

struct SparkView: View {
    var body: some View {
        ZStack {
            ForEach(0..<8) { index in
                SparkLine()
                    .rotationEffect(.degrees(Double(index) * 45))
            }
        }
        .frame(width: 200, height: 200)
    }
}

struct SparkLine: View {
    var body: some View {
        Capsule()
            .fill(Color.white)
            .frame(width: 3, height: 20)
            .offset(y: -90)
    }
}

#Preview {
    SplashScreenView(isActive: .constant(true))
}
