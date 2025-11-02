import Foundation
import SwiftData

enum HabitCategory: String, Codable, CaseIterable {
    case calories = "Calories"
    case exercise = "Exercise"
    case hobby = "Hobby"
    case waterIntake = "Water Intake"
    case travel = "Travel"
    case custom = "Custom"
}

enum TrackingFrequency: String, Codable, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case biweekly = "Bi-weekly"
    case monthly = "Monthly"
    
    var daysCount: Int {
        switch self {
        case .daily: return 1
        case .weekly: return 7
        case .biweekly: return 14
        case .monthly: return 30
        }
    }
}

@Model
final class Habit {
    var id: UUID
    var name: String
    var category: String // HabitCategory raw value
    var trackingFrequency: String // TrackingFrequency raw value
    var targetCount: Int // How many times per frequency period
    var isActive: Bool
    var createdDate: Date
    var iconName: String
    var color: String // Hex color code
    
    init(name: String, category: HabitCategory, trackingFrequency: TrackingFrequency, targetCount: Int, iconName: String = "checkmark.circle", color: String = "#007AFF") {
        self.id = UUID()
        self.name = name
        self.category = category.rawValue
        self.trackingFrequency = trackingFrequency.rawValue
        self.targetCount = targetCount
        self.isActive = true
        self.createdDate = Date()
        self.iconName = iconName
        self.color = color
    }
    
    var categoryEnum: HabitCategory {
        HabitCategory(rawValue: category) ?? .custom
    }
    
    var frequencyEnum: TrackingFrequency {
        TrackingFrequency(rawValue: trackingFrequency) ?? .daily
    }
}
