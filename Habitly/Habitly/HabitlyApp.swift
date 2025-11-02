import SwiftUI
import SwiftData

@main
struct HabitlyApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(
                for: Ingredient.self, 
                Recipe.self, 
                CalorieEntry.self, 
                DailyGoal.self,
                Habit.self,
                HabitLog.self
            )
            
            // Load sample data if needed
            let context = container.mainContext
            let ingredientDescriptor = FetchDescriptor<Ingredient>()
            let existingIngredients = (try? context.fetch(ingredientDescriptor)) ?? []
            
            if existingIngredients.isEmpty {
                SampleDataLoader.loadSampleData(context: context)
            }
            
            // Load sample habits if needed
            let habitDescriptor = FetchDescriptor<Habit>()
            let existingHabits = (try? context.fetch(habitDescriptor)) ?? []
            
            if existingHabits.isEmpty {
                SampleHabitLoader.loadSampleHabits(context: context)
            }
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            HabitsDashboardView()
                .modelContainer(container)
        }
    }
}
