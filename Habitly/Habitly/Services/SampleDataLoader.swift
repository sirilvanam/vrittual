import Foundation
import SwiftData

struct SampleDataLoader {
    @MainActor
    static func loadSampleData(context: ModelContext) {
        // Add sample ingredients
        let sampleIngredients = [
            Ingredient(name: "Banana", caloriesPerServing: 105, servingSize: "1 medium", category: "Fruit"),
            Ingredient(name: "Apple", caloriesPerServing: 95, servingSize: "1 medium", category: "Fruit"),
            Ingredient(name: "Chicken Breast", caloriesPerServing: 165, servingSize: "100g", category: "Protein"),
            Ingredient(name: "Brown Rice", caloriesPerServing: 216, servingSize: "1 cup cooked", category: "Grain"),
            Ingredient(name: "Broccoli", caloriesPerServing: 55, servingSize: "1 cup", category: "Vegetable"),
            Ingredient(name: "Eggs", caloriesPerServing: 155, servingSize: "2 large", category: "Protein"),
            Ingredient(name: "Oatmeal", caloriesPerServing: 150, servingSize: "1/2 cup dry", category: "Grain"),
            Ingredient(name: "Almonds", caloriesPerServing: 164, servingSize: "1 oz (23 nuts)", category: "Snack"),
            Ingredient(name: "Greek Yogurt", caloriesPerServing: 100, servingSize: "170g", category: "Dairy"),
            Ingredient(name: "Spinach", caloriesPerServing: 7, servingSize: "1 cup raw", category: "Vegetable"),
            Ingredient(name: "Salmon", caloriesPerServing: 206, servingSize: "100g", category: "Protein"),
            Ingredient(name: "Sweet Potato", caloriesPerServing: 112, servingSize: "1 medium", category: "Vegetable"),
            Ingredient(name: "Avocado", caloriesPerServing: 234, servingSize: "1 medium", category: "Fruit"),
            Ingredient(name: "Whole Wheat Bread", caloriesPerServing: 80, servingSize: "1 slice", category: "Grain"),
            Ingredient(name: "Peanut Butter", caloriesPerServing: 188, servingSize: "2 tbsp", category: "Snack"),
            Ingredient(name: "Milk", caloriesPerServing: 149, servingSize: "1 cup", category: "Dairy"),
            Ingredient(name: "Orange Juice", caloriesPerServing: 112, servingSize: "1 cup", category: "Beverage"),
            Ingredient(name: "Coffee", caloriesPerServing: 2, servingSize: "1 cup black", category: "Beverage")
        ]
        
        for ingredient in sampleIngredients {
            context.insert(ingredient)
        }
        
        // Add sample recipes
        let sampleRecipes = [
            Recipe(
                name: "Chicken & Rice Bowl",
                totalCalories: 446,
                servings: 1,
                ingredientNames: ["Chicken Breast (100g)", "Brown Rice (1 cup)", "Broccoli (1 cup)"],
                instructions: "1. Cook chicken breast\n2. Prepare brown rice\n3. Steam broccoli\n4. Combine in bowl"
            ),
            Recipe(
                name: "Breakfast Oatmeal",
                totalCalories: 350,
                servings: 1,
                ingredientNames: ["Oatmeal (1/2 cup)", "Banana (1)", "Almonds (1/2 oz)"],
                instructions: "1. Cook oatmeal\n2. Slice banana\n3. Top with almonds"
            ),
            Recipe(
                name: "Greek Yogurt Parfait",
                totalCalories: 259,
                servings: 1,
                ingredientNames: ["Greek Yogurt (170g)", "Apple (1)", "Almonds (1/2 oz)"],
                instructions: "1. Layer yogurt in bowl\n2. Chop apple\n3. Add apple and almonds"
            ),
            Recipe(
                name: "Salmon Dinner",
                totalCalories: 430,
                servings: 1,
                ingredientNames: ["Salmon (100g)", "Sweet Potato (1)", "Spinach (2 cups)"],
                instructions: "1. Bake salmon\n2. Roast sweet potato\n3. Sauté spinach"
            ),
            Recipe(
                name: "Avocado Toast",
                totalCalories: 394,
                servings: 1,
                ingredientNames: ["Whole Wheat Bread (2 slices)", "Avocado (1/2)", "Eggs (1)"],
                instructions: "1. Toast bread\n2. Mash avocado\n3. Fry egg\n4. Assemble"
            )
        ]
        
        for recipe in sampleRecipes {
            context.insert(recipe)
        }
        
        // Add default daily goal
        let defaultGoal = DailyGoal(targetCalories: 2000, isActive: true)
        context.insert(defaultGoal)
        
        try? context.save()
    }
}
