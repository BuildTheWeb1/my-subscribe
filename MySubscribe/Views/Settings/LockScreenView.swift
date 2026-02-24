//
//  LockScreenView.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 23.02.2026.
//

import SwiftUI

struct LockScreenView: View {
    @State private var authService = AuthenticationService.shared
    @State private var isAuthenticating = false
    @State private var showError = false
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                VStack(spacing: 16) {
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(AppColors.cardGradientBlue)
                    
                    Text("MySubscribe")
                        .font(.largeTitle.bold())
                        .foregroundStyle(AppColors.textPrimary)
                    
                    Text(String(localized: "Locked"))
                        .font(.headline)
                        .foregroundStyle(AppColors.textSecondary)
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    Button {
                        authenticate()
                    } label: {
                        HStack(spacing: 12) {
                            if isAuthenticating {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: authService.biometryIcon)
                                    .font(.title2)
                            }
                            
                            Text(String(localized: "Unlock with \(authService.biometryName)"))
                                .font(.headline)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppColors.cardGradientBlue)
                        .clipShape(.rect(cornerRadius: 16))
                    }
                    .disabled(isAuthenticating)
                    
                    if showError {
                        Text(String(localized: "Authentication failed. Please try again."))
                            .font(.caption)
                            .foregroundStyle(.red)
                            .transition(.opacity)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
        .task {
            try? await Task.sleep(for: .milliseconds(500))
            authenticate()
        }
    }
    
    private func authenticate() {
        guard !isAuthenticating else { return }
        
        isAuthenticating = true
        showError = false
        
        authService.authenticateWithBiometrics { success, error in
            isAuthenticating = false
            
            if !success {
                withAnimation {
                    showError = true
                }
            }
        }
    }
}

#Preview {
    LockScreenView()
}
