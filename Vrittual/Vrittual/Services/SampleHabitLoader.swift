import Foundation
import SwiftData

struct SampleHabitLoader {
    @MainActor
    static func loadSampleHabits(context: ModelContext) {
        let sampleHabits = [
            Habit(
                name: "Exercise",
                category: .exercise,
                trackingFrequency: .daily,
                targetCount: 1,
                iconName: "figure.run",
                color: "#FF3B30"
            ),
            Habit(
                name: "Drink Water",
                category: .waterIntake,
                trackingFrequency: .daily,
                targetCount: 8,
                iconName: "drop.fill",
                color: "#007AFF"
            ),
            Habit(
                name: "Read",
                category: .hobby,
                trackingFrequency: .daily,
                targetCount: 1,
                iconName: "book.fill",
                color: "#FF9500"
            ),
            Habit(
                name: "Weekly Trip",
                category: .travel,
                trackingFrequency: .weekly,
                targetCount: 1,
                iconName: "airplane",
                color: "#34C759"
            ),
            Habit(
                name: "Track Calories",
                category: .calories,
                trackingFrequency: .daily,
                targetCount: 3,
                iconName: "fork.knife",
                color: "#AF52DE"
            )
        ]
        
        for habit in sampleHabits {
            context.insert(habit)
        }
        
        try? context.save()
    }
}
