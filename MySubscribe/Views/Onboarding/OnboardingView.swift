//
//  OnboardingView.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 20.01.2026.
//

import SwiftUI

struct OnboardingStep {
    let image: String
    let title: String
    let description: String
}

struct OnboardingView: View {
    @Binding var isPresented: Bool
    @State private var currentStep = 0
    
    private let steps: [OnboardingStep] = [
        OnboardingStep(
            image: "Onboarding_step_1",
            title: String(localized: "Add a Subscription"),
            description: String(localized: "Add any recurring payment in one place.")
        ),
        OnboardingStep(
            image: "Onboarding_step_2",
            title: String(localized: "Edit Whenever You Like"),
            description: String(localized: "Update your subscriptions anytime with just a few taps.")
        ),
        OnboardingStep(
            image: "Onboarding_step_3",
            title: String(localized: "You're All Set!"),
            description: String(localized: "Track all your spending and stay on top of your budget.")
        )
    ]
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { }
            
            VStack(spacing: 0) {
                TabView(selection: $currentStep) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        OnboardingStepView(step: steps[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: currentStep)
                
                HStack {
                    if currentStep > 0 {
                        ChevronButton(direction: .back) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentStep -= 1
                            }
                        }
                    } else {
                        Spacer()
                            .frame(width: 44)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        ForEach(0..<steps.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentStep ? AppColors.textPrimary : AppColors.textSecondary.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut(duration: 0.2), value: currentStep)
                        }
                    }
                    
                    Spacer()
                    
                    if currentStep < steps.count - 1 {
                        ChevronButton(direction: .forward) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentStep += 1
                            }
                        }
                    } else {
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isPresented = false
                            }
                        } label: {
                            Text(String(localized: "Done"))
                                .font(.body.weight(.semibold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(AppColors.categoryFitness)
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .frame(maxWidth: 340, maxHeight: 420)
            .background(AppColors.background)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
        }
    }
}

struct OnboardingStepView: View {
    let step: OnboardingStep
    
    var body: some View {
        VStack(spacing: 20) {
            Image(step.image)
                .resizable()
                .scaledToFit()
                .frame(height: 140)
                .padding(.top, 24)
            
            Text(step.title)
                .font(.title2.bold())
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.center)
            
            Text(step.description)
                .font(.body)
                .foregroundStyle(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}

enum ChevronDirection {
    case forward, back
}

struct ChevronButton: View {
    let direction: ChevronDirection
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: direction == .forward ? "chevron.right" : "chevron.left")
                .font(.title2.weight(.semibold))
                .foregroundStyle(AppColors.textPrimary)
                .frame(width: 44, height: 44)
                .background(AppColors.secondaryBackground)
                .clipShape(Circle())
                .scaleEffect(isPressed ? 0.9 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PressableButtonStyle(isPressed: $isPressed))
    }
}

struct PressableButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { _, newValue in
                isPressed = newValue
            }
    }
}

#Preview {
    OnboardingView(isPresented: .constant(true))
}
