import Foundation
import SwiftData

@Model
final class CalorieEntry {
    var id: UUID
    var date: Date
    var name: String
    var calories: Double
    var entryType: String // "ingredient" or "recipe"
    var mealType: String // "breakfast", "lunch", "dinner", "snack"
    
    init(date: Date, name: String, calories: Double, entryType: String, mealType: String) {
        self.id = UUID()
        self.date = date
        self.name = name
        self.calories = calories
        self.entryType = entryType
        self.mealType = mealType
    }
}
