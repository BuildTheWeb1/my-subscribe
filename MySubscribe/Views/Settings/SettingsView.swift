//
//  SettingsView.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 23.02.2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var authService = AuthenticationService.shared
    @Environment(\.currencyService) private var currencyService
    @State private var showingLockToggleAlert = false
    @State private var showingCurrencyPicker = false
    
    var body: some View {
        NavigationStack {
            List {
                currencySection
                securitySection
                aboutSection
            }
            .navigationTitle(String(localized: "Settings"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.body.weight(.medium))
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
            }
        }
        .presentationCornerRadius(20)
        .presentationDragIndicator(.visible)
        .sheet(isPresented: $showingCurrencyPicker) {
            CurrencyPickerView()
        }
        .task {
            await currencyService.fetchRatesIfNeeded()
        }
        .onAppear {
            authService.refreshBiometryAvailability()
        }
    }
    
    private var securitySection: some View {
        Section {
            if authService.isBiometryAvailable {
                Toggle(isOn: Binding(
                    get: { authService.isLockEnabled },
                    set: { newValue in
                        if newValue {
                            authService.enableLockWithAuthentication { _ in }
                        } else {
                            authService.disableLock()
                        }
                    }
                )) {
                    Label {
                        Text(String(localized: "Lock with \(authService.biometryName)"))
                    } icon: {
                        Image(systemName: authService.biometryIcon)
                            .foregroundStyle(AppColors.categoryFitness)
                    }
                }
            } else {
                HStack {
                    Label {
                        Text(String(localized: "Biometric Lock"))
                    } icon: {
                        Image(systemName: "lock.fill")
                            .foregroundStyle(AppColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Text(String(localized: "Not Available"))
                        .font(.subheadline)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        } header: {
            Text(String(localized: "Security"))
        } footer: {
            if authService.isBiometryAvailable {
                Text(String(localized: "When enabled, \(authService.biometryName) will be required to open the app."))
            } else {
                Text(String(localized: "Biometric authentication is not available on this device."))
            }
        }
    }
    
    private var currencySection: some View {
        Section {
            Button {
                showingCurrencyPicker = true
            } label: {
                HStack {
                    Label {
                        Text(String(localized: "Display Currency"))
                    } icon: {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundStyle(AppColors.categoryFitness)
                    }
                    
                    Spacer()
                    
                    Text(currencyService.selectedCurrency.code)
                        .foregroundStyle(AppColors.textSecondary)
                    
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(AppColors.textSecondary.opacity(0.5))
                }
            }
            .buttonStyle(.plain)
            
            if currencyService.isLoading {
                HStack {
                    Text(String(localized: "Updating rates..."))
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)
                    Spacer()
                    ProgressView()
                }
            } else if let lastUpdated = currencyService.lastUpdated {
                HStack {
                    Text(String(localized: "Rates updated"))
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)
                    Spacer()
                    Text(lastUpdated, format: .relative(presentation: .named))
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        } header: {
            Text(String(localized: "Currency"))
        } footer: {
            VStack(alignment: .leading, spacing: 4) {
                Text(String(localized: "All amounts will be displayed in your selected currency."))
                Link(destination: URL(string: "https://www.exchangerate-api.com")!) {
                    Text(String(localized: "Rates by Exchange Rate API"))
                        .font(.caption)
                }
            }
        }
    }
    
    private var aboutSection: some View {
        Section {
            HStack {
                Text(String(localized: "Version"))
                Spacer()
                Text(appVersion)
                    .foregroundStyle(AppColors.textSecondary)
            }
            
            HStack {
                Text(String(localized: "Build"))
                Spacer()
                Text(buildNumber)
                    .foregroundStyle(AppColors.textSecondary)
            }
        } header: {
            Text(String(localized: "About"))
        }
    }
    
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
}

#Preview {
    SettingsView()
}
