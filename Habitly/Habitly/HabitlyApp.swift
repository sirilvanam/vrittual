import SwiftUI
import SwiftData

@main
struct HabitlyApp: App {
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .modelContainer(for: [
                    Ingredient.self,
                    Recipe.self,
                    CalorieEntry.self,
                    DailyGoal.self
                ])
                .onAppear {
                    loadSampleDataIfNeeded()
                }
        }
    }
    
    private func loadSampleDataIfNeeded() {
        let container = try? ModelContainer(for: Ingredient.self, Recipe.self, CalorieEntry.self, DailyGoal.self)
        guard let context = container?.mainContext else { return }
        
        let ingredientDescriptor = FetchDescriptor<Ingredient>()
        let existingIngredients = (try? context.fetch(ingredientDescriptor)) ?? []
        
        if existingIngredients.isEmpty {
            SampleDataLoader.loadSampleData(context: context)
        }
    }
}
