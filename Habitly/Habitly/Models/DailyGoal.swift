import Foundation
import SwiftData

@Model
final class DailyGoal {
    var id: UUID
    var targetCalories: Double
    var isActive: Bool
    
    init(targetCalories: Double, isActive: Bool = true) {
        self.id = UUID()
        self.targetCalories = targetCalories
        self.isActive = isActive
    }
}
