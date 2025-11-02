import SwiftUI
import SwiftData

struct ManageRecipesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Recipe.name) private var recipes: [Recipe]
    @State private var showingAddRecipe = false
    
    var body: some View {
        List {
            ForEach(recipes) { recipe in
                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.name)
                        .font(.headline)
                    HStack {
                        Text("\(Int(recipe.totalCalories)) cal total")
                        Text("•")
                        Text("\(recipe.servings) servings")
                        Text("•")
                        Text("\(Int(recipe.caloriesPerServing)) cal/serving")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            .onDelete(perform: deleteRecipes)
        }
        .navigationTitle("Recipes")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddRecipe = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddRecipe) {
            AddRecipeView()
        }
    }
    
    private func deleteRecipes(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(recipes[index])
        }
    }
}

struct AddRecipeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var totalCalories = ""
    @State private var servings = ""
    @State private var instructions = ""
    @State private var ingredientNames: [String] = [""]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Recipe Details")) {
                    TextField("Recipe name", text: $name)
                    TextField("Total calories", text: $totalCalories)
                        .keyboardType(.decimalPad)
                    TextField("Number of servings", text: $servings)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Ingredients")) {
                    ForEach(ingredientNames.indices, id: \.self) { index in
                        HStack {
                            TextField("Ingredient \(index + 1)", text: $ingredientNames[index])
                            
                            if ingredientNames.count > 1 {
                                Button(action: {
                                    ingredientNames.remove(at: index)
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    
                    Button(action: {
                        ingredientNames.append("")
                    }) {
                        Label("Add Ingredient", systemImage: "plus.circle.fill")
                    }
                }
                
                Section(header: Text("Instructions")) {
                    TextEditor(text: $instructions)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Add Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveRecipe()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
    
    private var isValid: Bool {
        !name.isEmpty && 
        !totalCalories.isEmpty && 
        !servings.isEmpty && 
        ingredientNames.contains(where: { !$0.isEmpty })
    }
    
    private func saveRecipe() {
        guard let caloriesValue = Double(totalCalories),
              let servingsValue = Int(servings) else { return }
        
        let filteredIngredients = ingredientNames.filter { !$0.isEmpty }
        
        let recipe = Recipe(
            name: name,
            totalCalories: caloriesValue,
            servings: servingsValue,
            ingredientNames: filteredIngredients,
            instructions: instructions
        )
        
        modelContext.insert(recipe)
        dismiss()
    }
}
