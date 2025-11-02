import Foundation
import SwiftData

@Model
final class Recipe {
    var id: UUID
    var name: String
    var totalCalories: Double
    var servings: Int
    var ingredientNames: [String]
    var instructions: String
    
    init(name: String, totalCalories: Double, servings: Int, ingredientNames: [String], instructions: String) {
        self.id = UUID()
        self.name = name
        self.totalCalories = totalCalories
        self.servings = servings
        self.ingredientNames = ingredientNames
        self.instructions = instructions
    }
    
    var caloriesPerServing: Double {
        totalCalories / Double(servings)
    }
}
