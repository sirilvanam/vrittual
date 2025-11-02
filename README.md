# Habitly - Calorie Tracking iOS App

Habitly is an iOS calorie tracking application designed to help you monitor your daily calorie intake and stay within your goals. The app provides an intuitive dashboard with visual progress indicators and easy input methods for logging your meals.

## Features

### 🎯 Dashboard with Goal Tracking
- **Visual Progress Circle**: Shows your daily calorie consumption vs. your goal
- **Remaining Calories**: Clear display of how many calories you have left for the day
- **Date Selection**: Track calories for any day, not just today
- **Color-Coded Status**: Green when under goal, red when over

### 🍎 Easy Calorie Input
- **Ingredient Database**: Pre-loaded with common ingredients and their calorie values
- **Recipe Database**: Save and select from custom recipes
- **Quick Selection**: Choose from breakfast, lunch, dinner, or snack categories
- **Search Functionality**: Quickly find ingredients or recipes
- **One-Tap Addition**: Add items to your daily log with a single tap

### 📊 Smart Organization
- **Meal Categorization**: Entries are automatically grouped by meal type
- **Entry Management**: Delete entries with a simple tap
- **Daily Summaries**: See all your meals organized by type

### ⚙️ Customization
- **Set Your Goal**: Customize your daily calorie target
- **Manage Database**: Add, edit, or remove ingredients and recipes
- **Sample Data**: Comes pre-loaded with 18 common ingredients and 5 recipes

## Sample Data Included

### Ingredients
- Fruits: Banana, Apple, Avocado
- Proteins: Chicken Breast, Eggs, Salmon
- Grains: Brown Rice, Oatmeal, Whole Wheat Bread
- Vegetables: Broccoli, Spinach, Sweet Potato
- Dairy: Greek Yogurt, Milk
- Snacks: Almonds, Peanut Butter
- Beverages: Orange Juice, Coffee

### Recipes
- Chicken & Rice Bowl (446 cal)
- Breakfast Oatmeal (350 cal)
- Greek Yogurt Parfait (259 cal)
- Salmon Dinner (430 cal)
- Avocado Toast (394 cal)

## Technology Stack

- **SwiftUI**: Modern declarative UI framework
- **SwiftData**: Persistent data storage using Apple's latest framework
- **iOS 17+**: Requires iOS 17 or later

## Installation

### Requirements
- Xcode 15.0 or later
- iOS 17.0 or later
- An iPhone or iOS Simulator

### Setup Steps

1. Clone the repository:
```bash
git clone https://github.com/sirilvanam/habitly.git
cd habitly
```

2. Open the project in Xcode:
```bash
open Habitly/Habitly.xcodeproj
```

3. Select your target device (iPhone simulator or physical device)

4. Build and run the project (⌘ + R)

## Usage

### First Launch
When you first launch the app, it will automatically load sample data including:
- 18 common ingredients with calorie information
- 5 healthy recipes
- Default daily goal of 2000 calories

### Adding a Calorie Entry
1. Tap the **+** button in the top right
2. Select your meal type (Breakfast, Lunch, Dinner, or Snack)
3. Choose the **Ingredients** or **Recipes** tab
4. Use the search bar to find what you're looking for
5. Tap any item to add it to your daily log

### Managing Your Goal
1. Tap the **gear icon** in the top left
2. Enter your desired daily calorie target
3. Tap **Save Goal**

### Adding Custom Items
1. Go to **Settings** → **Manage Ingredients** or **Manage Recipes**
2. Tap the **+** button
3. Fill in the details
4. Tap **Save**

### Deleting Entries
- Swipe left on any entry in the main dashboard to delete it
- Or tap the trash icon next to the entry

## Project Structure

```
Habitly/
├── Habitly/
│   ├── HabitlyApp.swift          # Main app entry point
│   ├── Models/
│   │   ├── Ingredient.swift       # Ingredient data model
│   │   ├── Recipe.swift           # Recipe data model
│   │   ├── CalorieEntry.swift     # Calorie entry data model
│   │   └── DailyGoal.swift        # Daily goal data model
│   ├── Views/
│   │   ├── DashboardView.swift    # Main dashboard
│   │   ├── AddCalorieEntryView.swift  # Add entry interface
│   │   ├── SettingsView.swift     # Settings screen
│   │   ├── ManageIngredientsView.swift  # Ingredient management
│   │   └── ManageRecipesView.swift      # Recipe management
│   ├── Services/
│   │   ├── CalorieService.swift   # Business logic layer
│   │   └── SampleDataLoader.swift # Sample data provider
│   └── Assets.xcassets/           # App assets
└── Habitly.xcodeproj/             # Xcode project file
```

## Data Models

### Ingredient
- Name
- Calories per serving
- Serving size
- Category (Fruit, Vegetable, Protein, etc.)

### Recipe
- Name
- Total calories
- Number of servings
- Ingredient list
- Instructions

### Calorie Entry
- Date
- Item name
- Calories
- Entry type (ingredient or recipe)
- Meal type (breakfast, lunch, dinner, snack)

### Daily Goal
- Target calories
- Active status

## Future Enhancements

Potential features for future versions:
- Weekly and monthly statistics
- Weight tracking integration
- Nutritional macros (protein, carbs, fats)
- Barcode scanning
- Photo logging
- Export data to CSV
- Dark mode optimization
- Widget support
- Apple Health integration

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.

## Support

For issues, questions, or suggestions, please open an issue on GitHub.

---

Built with ❤️ for iPhone users who want to track their calories easily.