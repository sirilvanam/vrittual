import Foundation
import SwiftData

@Model
final class HabitLog {
    var id: UUID
    var habitId: UUID
    var date: Date
    var completed: Bool
    var notes: String
    var value: Double? // Optional value for quantifiable habits (e.g., glasses of water, minutes exercised)
    
    init(habitId: UUID, date: Date, completed: Bool, notes: String = "", value: Double? = nil) {
        self.id = UUID()
        self.habitId = habitId
        self.date = date
        self.completed = completed
        self.notes = notes
        self.value = value
    }
}
