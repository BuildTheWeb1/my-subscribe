//
//  DebugConsoleView.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 15.01.2026.
//

import SwiftUI

#if DEBUG
struct DebugConsoleView: View {
    let subscriptions: [Subscription]
    @Environment(\.dismiss) private var dismiss
    
    private var jsonData: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        
        guard let data = try? encoder.encode(subscriptions),
              let jsonString = String(data: data, encoding: .utf8) else {
            return "Failed to encode data"
        }
        return jsonString
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Stored Subscriptions")
                            .font(.headline)
                        Spacer()
                        Text("\(subscriptions.count) items")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Text(jsonData)
                        .font(.system(.caption, design: .monospaced))
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding()
            }
            .navigationTitle("Debug Console")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(Color.black)
                }
            }
        }
    }
}

#Preview {
    DebugConsoleView(subscriptions: Subscription.samples)
}
#endif
