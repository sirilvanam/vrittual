import Foundation
import SwiftData

@MainActor
class CalorieService {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Calorie Entries
    
    func addCalorieEntry(name: String, calories: Double, entryType: String, mealType: String) throws {
        let entry = CalorieEntry(
            date: Date(),
            name: name,
            calories: calories,
            entryType: entryType,
            mealType: mealType
        )
        modelContext.insert(entry)
        try modelContext.save()
    }
    
    func getCaloriesForDate(_ date: Date) throws -> [CalorieEntry] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = #Predicate<CalorieEntry> { entry in
            entry.date >= startOfDay && entry.date < endOfDay
        }
        
        let descriptor = FetchDescriptor<CalorieEntry>(predicate: predicate)
        return try modelContext.fetch(descriptor)
    }
    
    func getTotalCaloriesForDate(_ date: Date) throws -> Double {
        let entries = try getCaloriesForDate(date)
        return entries.reduce(0) { $0 + $1.calories }
    }
    
    func deleteEntry(_ entry: CalorieEntry) throws {
        modelContext.delete(entry)
        try modelContext.save()
    }
    
    // MARK: - Daily Goal
    
    func getDailyGoal() throws -> DailyGoal? {
        let descriptor = FetchDescriptor<DailyGoal>(
            predicate: #Predicate { $0.isActive }
        )
        return try modelContext.fetch(descriptor).first
    }
    
    func setDailyGoal(targetCalories: Double) throws {
        // Deactivate existing goals
        let existingGoals = try modelContext.fetch(FetchDescriptor<DailyGoal>())
        existingGoals.forEach { $0.isActive = false }
        
        // Create new active goal
        let newGoal = DailyGoal(targetCalories: targetCalories, isActive: true)
        modelContext.insert(newGoal)
        try modelContext.save()
    }
    
    // MARK: - Ingredients
    
    func getAllIngredients() throws -> [Ingredient] {
        let descriptor = FetchDescriptor<Ingredient>(
            sortBy: [SortDescriptor(\.name)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    func addIngredient(_ ingredient: Ingredient) throws {
        modelContext.insert(ingredient)
        try modelContext.save()
    }
    
    // MARK: - Recipes
    
    func getAllRecipes() throws -> [Recipe] {
        let descriptor = FetchDescriptor<Recipe>(
            sortBy: [SortDescriptor(\.name)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    func addRecipe(_ recipe: Recipe) throws {
        modelContext.insert(recipe)
        try modelContext.save()
    }
}
