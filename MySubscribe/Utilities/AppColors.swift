//
//  AppColors.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 15.01.2026.
//

import SwiftUI

enum AppColors {
    // MARK: - Primary Palette (from spec)
    static let mint = Color(hex: "DDF7F6")
    static let skyBlue = Color(hex: "CCEAF7")
    static let darkBackground = Color(hex: "0F1012")
    static let coral = Color(hex: "C96F5E")
    static let slate = Color(hex: "2B3744")
    
    // MARK: - Card Background Colors (inspired by screenshot)
    static let cardLavender = Color(hex: "E8E4F4")
    static let cardMint = Color(hex: "D4F5F3")
    static let cardPeach = Color(hex: "FDEAE8")
    static let cardYellow = Color(hex: "FDF6E3")
    static let cardGreen = Color(hex: "E8F5E9")
    static let cardBlue = Color(hex: "E3F2FD")
    static let cardPink = Color(hex: "FCE4EC")
    static let cardOrange = Color(hex: "FFF3E0")
    static let cardPurple = Color(hex: "F3E5F5")
    
    // MARK: - Gradient Backgrounds
    static let cardGradientLavender = LinearGradient(
        colors: [Color(hex: "E8E4F4"), Color(hex: "D4F5F3")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradientMint = LinearGradient(
        colors: [Color(hex: "D4F5F3"), Color(hex: "E3F2FD")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradientPeach = LinearGradient(
        colors: [Color(hex: "FDEAE8"), Color(hex: "FCE4EC")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Semantic Colors
    static let background = Color(hex: "F8F9FA")
    static let cardShadow = Color.black.opacity(0.08)
    static let textPrimary = Color(hex: "1A1A1A")
    static let textSecondary = Color(hex: "6B7280")
    
    // MARK: - Category Colors
    static func categoryColor(for category: SubscriptionCategory) -> Color {
        switch category {
        case .streaming: return cardPeach
        case .software: return cardLavender
        case .fitness: return cardMint
        case .productivity: return cardBlue
        case .gaming: return cardPurple
        case .music: return cardGreen
        case .news: return cardYellow
        case .cloud: return cardBlue
        case .other: return cardOrange
        }
    }
    
    // MARK: - Preset Card Colors
    static let presetColors: [Color] = [
        cardLavender, cardMint, cardPeach, cardYellow,
        cardGreen, cardBlue, cardPink, cardOrange, cardPurple
    ]
}

// MARK: - Color Extension for Hex Support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    func toHex() -> String? {
        guard let components = UIColor(self).cgColor.components else { return nil }
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        return String(format: "%02X%02X%02X", r, g, b)
    }
}
