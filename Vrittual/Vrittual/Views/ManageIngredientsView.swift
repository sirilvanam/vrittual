import SwiftUI
import SwiftData

struct ManageIngredientsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Ingredient.name) private var ingredients: [Ingredient]
    @State private var showingAddIngredient = false
    
    var body: some View {
        List {
            ForEach(ingredients) { ingredient in
                VStack(alignment: .leading, spacing: 4) {
                    Text(ingredient.name)
                        .font(.headline)
                    HStack {
                        Text("\(Int(ingredient.caloriesPerServing)) cal")
                        Text("•")
                        Text(ingredient.servingSize)
                        Text("•")
                        Text(ingredient.category)
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            .onDelete(perform: deleteIngredients)
        }
        .navigationTitle("Ingredients")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddIngredient = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddIngredient) {
            AddIngredientView()
        }
    }
    
    private func deleteIngredients(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(ingredients[index])
        }
    }
}

struct AddIngredientView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var calories = ""
    @State private var servingSize = ""
    @State private var category = ""
    
    let categories = ["Fruit", "Vegetable", "Protein", "Grain", "Dairy", "Snack", "Beverage", "Other"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Ingredient Details")) {
                    TextField("Name", text: $name)
                    TextField("Calories per serving", text: $calories)
                        .keyboardType(.decimalPad)
                    TextField("Serving size (e.g., 100g, 1 cup)", text: $servingSize)
                    
                    Picker("Category", selection: $category) {
                        Text("Select category").tag("")
                        ForEach(categories, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }
                }
            }
            .navigationTitle("Add Ingredient")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveIngredient()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
    
    private var isValid: Bool {
        !name.isEmpty && !calories.isEmpty && !servingSize.isEmpty && !category.isEmpty
    }
    
    private func saveIngredient() {
        guard let caloriesValue = Double(calories) else { return }
        
        let ingredient = Ingredient(
            name: name,
            caloriesPerServing: caloriesValue,
            servingSize: servingSize,
            category: category
        )
        
        modelContext.insert(ingredient)
        dismiss()
    }
}
