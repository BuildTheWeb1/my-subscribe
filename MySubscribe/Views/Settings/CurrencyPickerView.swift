//
//  CurrencyPickerView.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 23.02.2026.
//

import SwiftUI

struct CurrencyPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.currencyService) private var currencyService
    @State private var searchText = ""
    
    private var filteredCurrencies: [Currency] {
        if searchText.isEmpty {
            return Currency.supportedCurrencies
        }
        return Currency.supportedCurrencies.filter {
            $0.name.localizedStandardContains(searchText) ||
            $0.code.localizedStandardContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredCurrencies) { currency in
                    Button {
                        currencyService.setSelectedCurrency(currency.code)
                        dismiss()
                    } label: {
                        HStack {
                            Text(currency.symbol)
                                .font(.title2)
                                .frame(width: 40)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(currency.code)
                                    .font(.body.weight(.medium))
                                    .foregroundStyle(AppColors.textPrimary)
                                
                                Text(currency.name)
                                    .font(.caption)
                                    .foregroundStyle(AppColors.textSecondary)
                            }
                            
                            Spacer()
                            
                            if currency.code == currencyService.selectedCurrencyCode {
                                Image(systemName: "checkmark")
                                    .font(.body.weight(.semibold))
                                    .foregroundStyle(AppColors.categoryFitness)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .searchable(text: $searchText, prompt: String(localized: "Search currencies"))
            .navigationTitle(String(localized: "Select Currency"))
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
    }
}

#Preview {
    CurrencyPickerView()
}
