import Foundation
import SwiftData

@Model
final class Ingredient {
    var id: UUID
    var name: String
    var caloriesPerServing: Double
    var servingSize: String
    var category: String
    
    init(name: String, caloriesPerServing: Double, servingSize: String, category: String) {
        self.id = UUID()
        self.name = name
        self.caloriesPerServing = caloriesPerServing
        self.servingSize = servingSize
        self.category = category
    }
}
