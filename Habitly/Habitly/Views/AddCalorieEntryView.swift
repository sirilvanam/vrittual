import SwiftUI
import SwiftData

struct AddCalorieEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var ingredients: [Ingredient]
    @Query private var recipes: [Recipe]
    
    let selectedDate: Date
    
    @State private var selectedTab = 0
    @State private var selectedMealType = "breakfast"
    @State private var searchText = ""
    
    private var calorieService: CalorieService {
        CalorieService(modelContext: modelContext)
    }
    
    private var filteredIngredients: [Ingredient] {
        if searchText.isEmpty {
            return ingredients
        }
        return ingredients.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    private var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return recipes
        }
        return recipes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    let mealTypes = ["breakfast", "lunch", "dinner", "snack"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Meal Type Picker
                Picker("Meal Type", selection: $selectedMealType) {
                    ForEach(mealTypes, id: \.self) { type in
                        Text(type.capitalized).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Tab Selector
                Picker("Source", selection: $selectedTab) {
                    Text("Ingredients").tag(0)
                    Text("Recipes").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search...", text: $searchText)
                        .textFieldStyle(.plain)
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding()
                
                // Content
                if selectedTab == 0 {
                    ingredientsList
                } else {
                    recipesList
                }
            }
            .navigationTitle("Add Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var ingredientsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if filteredIngredients.isEmpty {
                    Text("No ingredients found")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(filteredIngredients) { ingredient in
                        Button(action: {
                            addIngredient(ingredient)
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(ingredient.name)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                    Text("\(ingredient.servingSize) • \(ingredient.category)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Text("\(Int(ingredient.caloriesPerServing)) cal")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.blue)
                                    .font(.title3)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
        }
    }
    
    private var recipesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if filteredRecipes.isEmpty {
                    Text("No recipes found")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(filteredRecipes) { recipe in
                        Button(action: {
                            addRecipe(recipe)
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(recipe.name)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                    Text("\(recipe.servings) servings • \(Int(recipe.caloriesPerServing)) cal/serving")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Text("\(Int(recipe.totalCalories)) cal")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.blue)
                                    .font(.title3)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
        }
    }
    
    private func addIngredient(_ ingredient: Ingredient) {
        try? calorieService.addCalorieEntry(
            name: ingredient.name,
            calories: ingredient.caloriesPerServing,
            entryType: "ingredient",
            mealType: selectedMealType,
            date: selectedDate
        )
        dismiss()
    }
    
    private func addRecipe(_ recipe: Recipe) {
        try? calorieService.addCalorieEntry(
            name: recipe.name,
            calories: recipe.caloriesPerServing,
            entryType: "recipe",
            mealType: selectedMealType,
            date: selectedDate
        )
        dismiss()
    }
}
