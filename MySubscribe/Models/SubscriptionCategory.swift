//
//  SubscriptionCategory.swift
//  MySubscribe
//
//  Created by WebSpace Developer on 15.01.2026.
//

import Foundation
import SwiftUI

enum SubscriptionCategory: String, Codable, CaseIterable, Identifiable {
    case streaming = "Streaming"
    case software = "Software"
    case fitness = "Fitness"
    case productivity = "Productivity"
    case gaming = "Gaming"
    case music = "Music"
    case news = "News"
    case cloud = "Cloud Storage"
    case education = "Education"
    case utilities = "Utilities"
    case other = "Other"
    
    var id: String { rawValue }
    
    var systemIcon: String {
        switch self {
        case .streaming: return "play.tv.fill"
        case .software: return "inset.filled.rectangle.and.pointer.arrow"
        case .fitness: return "figure.run"
        case .productivity: return "briefcase.fill"
        case .gaming: return "gamecontroller.fill"
        case .music: return "music.note"
        case .news: return "newspaper.fill"
        case .cloud: return "cloud.fill"
        case .education: return "book.fill"
        case .utilities: return "wrench.and.screwdriver.fill"
        case .other: return "star.fill"
        }
    }
    
    var color: Color {
        AppColors.categoryColor(for: self)
    }
}
