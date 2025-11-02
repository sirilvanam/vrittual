# Vrittual - Comprehensive Habit Tracking iOS App

Vrittual is an iOS habit tracking application that helps you build and maintain healthy habits. Track calories, exercise, hobbies, water intake, travel, and more - all with flexible tracking frequencies (daily, weekly, bi-weekly, monthly) and comprehensive progress dashboards.

## Features

### 🎯 Multi-Habit Dashboard
- **Overall Progress Summary**: See completed vs. missed habits at a glance
- **Success Rate**: Visual percentage showing how well you're sticking to your plan
- **Individual Habit Cards**: Progress bars for each habit with quick completion toggle
- **Color-Coded Status**: Green for on-track, orange for behind schedule
- **Flexible Tracking**: Support for daily, weekly, bi-weekly, and monthly habits

### 📋 Habit Categories
- **Exercise**: Track workouts and physical activity
- **Water Intake**: Monitor hydration goals
- **Hobbies**: Reading, music, art, and more
- **Travel**: Weekly or monthly trip tracking
- **Calories**: Full calorie tracking integration
- **Custom**: Create any habit you want

### 📊 Detailed Tracking & Statistics
- **Completion Tracking**: Mark habits as complete or missed
- **Streak Counter**: See your current consecutive completion streak
- **Activity History**: View last 30 days of logs
- **Manual Logging**: Add entries with notes and numeric values
- **Effectiveness Metrics**: See how many times you've stuck to vs. missed your plan

### 🍎 Calorie Tracking (Integrated)
- **Visual Progress Circle**: Shows your daily calorie consumption vs. your goal
- **Ingredient Database**: Pre-loaded with 18 common ingredients
- **Recipe Database**: 5 pre-loaded recipes, add your own
- **Quick Selection**: Choose from breakfast, lunch, dinner, or snack categories
- **Search Functionality**: Quickly find ingredients or recipes
- **Date Selection**: Track calories for any day, not just today

### ⚙️ Customization
- **Custom Habits**: Name, icon, color, frequency, and target count
- **Icon Selection**: 18+ icons to choose from
- **Color Themes**: 10 color options per habit
- **Flexible Targets**: Set any target count (e.g., 3x per week, 8x per day)
- **Sample Data**: Pre-loaded with 5 example habits to get started

## Sample Data Included

### Sample Habits
- Exercise (daily, 1x)
- Drink Water (daily, 8x)
- Read (daily, 1x)
- Weekly Trip (weekly, 1x)
- Track Calories (daily, 3x)

### Ingredients (for Calorie Tracking)
- Fruits: Banana, Apple, Avocado
- Proteins: Chicken Breast, Eggs, Salmon
- Grains: Brown Rice, Oatmeal, Whole Wheat Bread
- Vegetables: Broccoli, Spinach, Sweet Potato
- Dairy: Greek Yogurt, Milk
- Snacks: Almonds, Peanut Butter
- Beverages: Orange Juice, Coffee

### Recipes (for Calorie Tracking)
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
open Vrittual/Vrittual.xcodeproj
```

3. Select your target device (iPhone simulator or physical device)

4. Build and run the project (⌘ + R)

## Usage

### First Launch
When you first launch the app, it will automatically load sample data including:
- 5 sample habits (exercise, water, reading, travel, calories)
- 18 common ingredients with calorie information
- 5 healthy recipes
- Default daily goal of 2000 calories

### Main Dashboard (Habits)
The main screen shows your habit tracking dashboard with:
- Overall summary: completed, missed, and success rate
- Individual habit cards with progress bars
- Quick toggle to mark habits complete
- Tap any habit to see detailed history

### Adding a New Habit
1. Tap the **+** button in the top right
2. Enter habit name and select category
3. Choose tracking frequency (daily, weekly, bi-weekly, monthly)
4. Set target count (e.g., 3x per week)
5. Pick an icon and color
6. Preview and save

### Tracking Habits
- Tap the circle icon on any habit card to mark as complete/incomplete
- Swipe down to refresh statistics
- Tap a habit card to view detailed history and statistics

### Viewing Calorie Tracking
1. Tap the **fork/knife icon** in the top left to access calorie tracking
2. Same interface as before for logging meals
3. Use the date picker to track any day

### Adding a Calorie Entry
1. From calorie dashboard, tap the **+** button
2. Select your meal type (Breakfast, Lunch, Dinner, or Snack)
3. Choose the **Ingredients** or **Recipes** tab
4. Use the search bar to find what you're looking for
5. Tap any item to add it to your daily log

### Managing Settings
1. From calorie tracking, tap the **gear icon**
2. Adjust your daily calorie target
3. Manage ingredients and recipes databases

### Deleting Entries
- Tap the trash icon next to calorie entries to delete them
- Swipe to delete items from ingredient/recipe lists

## Project Structure

```
Vrittual/
├── Vrittual/
│   ├── VrittualApp.swift          # Main app entry point
│   ├── Models/
│   │   ├── Habit.swift            # Habit definition model
│   │   ├── HabitLog.swift         # Habit tracking logs
│   │   ├── Ingredient.swift       # Ingredient data model
│   │   ├── Recipe.swift           # Recipe data model
│   │   ├── CalorieEntry.swift     # Calorie entry data model
│   │   └── DailyGoal.swift        # Daily goal data model
│   ├── Views/
│   │   ├── HabitsDashboardView.swift   # Main habits dashboard
│   │   ├── AddHabitView.swift          # Add habit interface
│   │   ├── HabitDetailView.swift       # Habit details & history
│   │   ├── DashboardView.swift         # Calorie dashboard
│   │   ├── AddCalorieEntryView.swift   # Add entry interface
│   │   ├── SettingsView.swift     # Settings screen
│   │   ├── ManageIngredientsView.swift  # Ingredient management
│   │   └── ManageRecipesView.swift      # Recipe management
│   ├── Services/
│   │   ├── HabitService.swift         # Habit tracking logic
│   │   ├── SampleHabitLoader.swift    # Sample habits
│   │   ├── CalorieService.swift       # Calorie tracking logic
│   │   └── SampleDataLoader.swift     # Sample calorie data
│   └── Assets.xcassets/           # App assets
└── Vrittual.xcodeproj/             # Xcode project file
```

## Data Models

### Habit
- Name
- Category (Exercise, Water, Hobby, Travel, Calories, Custom)
- Tracking frequency (Daily, Weekly, Bi-weekly, Monthly)
- Target count per period
- Icon and color customization

### HabitLog
- Associated habit ID
- Date and time
- Completion status
- Optional notes
- Optional numeric value

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