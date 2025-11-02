# Habitly Architecture Documentation

## 🏗️ Application Architecture

Habitly follows a clean, modular architecture pattern inspired by MVVM (Model-View-ViewModel) principles, leveraging SwiftUI's declarative paradigm and SwiftData for persistence.

## 📐 Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                        HabitlyApp.swift                      │
│                     (Application Entry)                      │
│  - Configures SwiftData ModelContainer                      │
│  - Loads sample data on first launch                        │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                          Views Layer                         │
├─────────────────────────────────────────────────────────────┤
│  DashboardView            │  Primary interface              │
│  AddCalorieEntryView      │  Entry creation                 │
│  SettingsView             │  Configuration                  │
│  ManageIngredientsView    │  Ingredient CRUD                │
│  ManageRecipesView        │  Recipe CRUD                    │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                       Services Layer                         │
├─────────────────────────────────────────────────────────────┤
│  CalorieService           │  Business logic & data ops      │
│  SampleDataLoader         │  Initial data population        │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                        Models Layer                          │
├─────────────────────────────────────────────────────────────┤
│  @Model Ingredient        │  Food items database            │
│  @Model Recipe            │  Meal combinations              │
│  @Model CalorieEntry      │  Daily log entries              │
│  @Model DailyGoal         │  Target calories                │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                    SwiftData Framework                       │
│                  (Persistence Layer)                         │
│  - Local SQLite database                                    │
│  - Automatic iCloud sync (if enabled)                       │
│  - Query API with predicates                                │
└─────────────────────────────────────────────────────────────┘
```

## 🔄 Data Flow

### Reading Data Flow
```
User View Request
       ↓
   @Query macro
       ↓
SwiftData ModelContext
       ↓
   Fetch from DB
       ↓
Reactive Update to View
```

### Writing Data Flow
```
User Action (Add/Edit/Delete)
       ↓
CalorieService method
       ↓
ModelContext.insert/delete/modify
       ↓
ModelContext.save()
       ↓
SwiftData persists to DB
       ↓
@Query automatically refreshes
       ↓
View updates reactively
```

## 📦 Component Breakdown

### 1. App Layer (`HabitlyApp.swift`)
**Responsibility:** Application lifecycle and initial setup

```swift
@main
struct HabitlyApp: App {
    // Configures ModelContainer for SwiftData
    // Loads sample data on first launch
    // Sets up main view hierarchy
}
```

**Key Features:**
- SwiftUI App protocol entry point
- ModelContainer configuration for all model types
- Sample data initialization check

---

### 2. Views Layer

#### `DashboardView.swift`
**Responsibility:** Main interface showing daily progress

**Key Components:**
- Date picker for viewing any day
- Circular progress indicator
- Statistics display (remaining/goal)
- Grouped meal entries list
- Navigation to settings and add entry

**Data Dependencies:**
- `@Query` for CalorieEntry
- `@Query` for DailyGoal
- `@Environment(\.modelContext)`

#### `AddCalorieEntryView.swift`
**Responsibility:** Interface for logging food intake

**Key Components:**
- Meal type segmented control
- Ingredient/Recipe tabs
- Search functionality
- Filterable lists
- One-tap item addition

**Data Dependencies:**
- `@Query` for Ingredient
- `@Query` for Recipe
- CalorieService for adding entries

#### `SettingsView.swift`
**Responsibility:** Configuration and navigation hub

**Key Components:**
- Goal input form
- Current goal display
- Navigation to data management

**Data Dependencies:**
- `@Query` for DailyGoal
- CalorieService for updating goals

#### `ManageIngredientsView.swift`
**Responsibility:** CRUD operations for ingredients

**Key Components:**
- Ingredient list with sorting
- Add ingredient form
- Swipe-to-delete
- Category selection

#### `ManageRecipesView.swift`
**Responsibility:** CRUD operations for recipes

**Key Components:**
- Recipe list with sorting
- Add recipe form
- Dynamic ingredient fields
- Instructions editor

---

### 3. Services Layer

#### `CalorieService.swift`
**Responsibility:** Business logic and data operations

**Core Methods:**
```swift
// Calorie Entry Management
func addCalorieEntry(...) throws
func getCaloriesForDate(_ date: Date) throws -> [CalorieEntry]
func getTotalCaloriesForDate(_ date: Date) throws -> Double
func deleteEntry(_ entry: CalorieEntry) throws

// Goal Management
func getDailyGoal() throws -> DailyGoal?
func setDailyGoal(targetCalories: Double) throws

// Database Access
func getAllIngredients() throws -> [Ingredient]
func getAllRecipes() throws -> [Recipe]
func addIngredient(_ ingredient: Ingredient) throws
func addRecipe(_ recipe: Recipe) throws
```

**Design Pattern:** Service/Repository pattern
- Encapsulates all data access
- Provides abstraction over SwiftData
- Centralized business logic
- Error handling

#### `SampleDataLoader.swift`
**Responsibility:** Initial data population

**Data Provided:**
- 18 pre-configured ingredients
- 5 healthy recipe templates
- Default 2000 calorie goal

**Execution:** One-time on first app launch

---

### 4. Models Layer

#### `Ingredient.swift`
```swift
@Model
final class Ingredient {
    var id: UUID
    var name: String
    var caloriesPerServing: Double
    var servingSize: String
    var category: String
}
```
**Purpose:** Represents individual food items

#### `Recipe.swift`
```swift
@Model
final class Recipe {
    var id: UUID
    var name: String
    var totalCalories: Double
    var servings: Int
    var ingredientNames: [String]
    var instructions: String
    
    var caloriesPerServing: Double { /* computed */ }
}
```
**Purpose:** Represents complete meals

#### `CalorieEntry.swift`
```swift
@Model
final class CalorieEntry {
    var id: UUID
    var date: Date
    var name: String
    var calories: Double
    var entryType: String
    var mealType: String
}
```
**Purpose:** Represents logged food intake

#### `DailyGoal.swift`
```swift
@Model
final class DailyGoal {
    var id: UUID
    var targetCalories: Double
    var isActive: Bool
}
```
**Purpose:** Represents user's calorie target

**Note:** All models use `@Model` macro for SwiftData integration

---

## 🔐 Data Persistence Strategy

### SwiftData Features Used:

1. **@Model Macro**
   - Automatic property observation
   - Relationship management
   - Migration support

2. **ModelContainer**
   - Configured at app level
   - Handles all model types
   - Provides ModelContext

3. **ModelContext**
   - Injected via @Environment
   - Tracks changes
   - Handles saves

4. **@Query Property Wrapper**
   - Reactive data fetching
   - Automatic updates
   - Predicate filtering
   - Sorting support

### Database Schema:

```
Ingredients Table
├── id (UUID, Primary Key)
├── name (String)
├── caloriesPerServing (Double)
├── servingSize (String)
└── category (String)

Recipes Table
├── id (UUID, Primary Key)
├── name (String)
├── totalCalories (Double)
├── servings (Int)
├── ingredientNames (Array<String>)
└── instructions (String)

CalorieEntries Table
├── id (UUID, Primary Key)
├── date (Date, Indexed)
├── name (String)
├── calories (Double)
├── entryType (String)
└── mealType (String)

DailyGoals Table
├── id (UUID, Primary Key)
├── targetCalories (Double)
└── isActive (Bool, Indexed)
```

---

## 🎯 Design Decisions

### Why SwiftData?
- **Modern:** Apple's latest persistence framework
- **Simple:** Less boilerplate than Core Data
- **Powerful:** Full SwiftUI integration
- **Reactive:** Automatic view updates
- **Cloud:** Built-in iCloud sync support

### Why Service Layer?
- **Separation:** Keep views simple
- **Testability:** Isolate business logic
- **Reusability:** Share code across views
- **Maintainability:** Centralized data operations

### Why MVVM-inspired?
- **SwiftUI Native:** Works with framework patterns
- **Reactive:** Leverages @State and @Query
- **Declarative:** View as function of state
- **Simple:** No complex bindings needed

### Why No Coordinators?
- **SwiftUI Navigation:** Native NavigationStack
- **Simple App:** Limited navigation complexity
- **Future-Ready:** Can add if needed

---

## 🔄 State Management

### View State
```swift
@State private var showingAddEntry = false
@State private var selectedDate = Date()
@State private var searchText = ""
```
- Local to view
- Triggers re-renders
- Transient data

### Persistent State
```swift
@Query private var calorieEntries: [CalorieEntry]
@Query(filter: #Predicate<DailyGoal> { $0.isActive })
    private var activeGoals: [DailyGoal]
```
- From SwiftData
- Automatically updates
- Survives app restarts

### Environment State
```swift
@Environment(\.modelContext) private var modelContext
@Environment(\.dismiss) private var dismiss
```
- Passed down hierarchy
- Shared resources
- System behaviors

---

## 🚀 Performance Considerations

### Optimizations Implemented:

1. **Lazy Loading**
   - LazyVStack for long lists
   - Loads only visible items

2. **Efficient Queries**
   - Predicates filter at DB level
   - Only fetch needed data
   - Date-based filtering

3. **Computed Properties**
   - Recipe calories per serving
   - Dashboard calculations
   - No stored duplicates

4. **Minimal Re-renders**
   - Targeted @State usage
   - Precise @Query filters
   - SwiftUI diffing

### Future Optimizations:

1. **Pagination**
   - For very large datasets
   - Infinite scroll support

2. **Caching**
   - Pre-compute statistics
   - Cache search results

3. **Background Tasks**
   - Export operations
   - Data sync

---

## 🧪 Testing Strategy

### Unit Tests (Recommended):
```swift
CalorieServiceTests
├── testAddCalorieEntry
├── testGetTotalCaloriesForDate
├── testSetDailyGoal
├── testAddIngredient
└── testAddRecipe
```

### Integration Tests:
- Test view + service interactions
- Verify SwiftData persistence
- Check query performance

### UI Tests:
- Test user flows
- Verify navigation
- Check accessibility

---

## 📈 Scalability Considerations

### Current Limitations:
- Single user per device
- No backend sync (beyond iCloud)
- No nutritional macros
- No meal planning

### Extensibility Points:
1. **Add New Models:** Easy with SwiftData
2. **New Views:** SwiftUI composition
3. **API Integration:** Add networking service
4. **Analytics:** Add tracking service
5. **Export:** Add export service

---

## 🔮 Future Architecture Enhancements

### Potential Additions:

1. **Networking Layer**
   - API service for cloud backup
   - Recipe sharing
   - Nutrition database lookup

2. **Analytics Service**
   - Track usage patterns
   - Generate insights
   - Weekly/monthly reports

3. **Notification Service**
   - Meal reminders
   - Goal alerts
   - Streak tracking

4. **Widget Extension**
   - Home screen widget
   - Lock screen widget
   - Today's progress at a glance

5. **Watch App**
   - Quick logging
   - Progress complication
   - Siri shortcuts

---

This architecture provides a solid foundation that's both simple for the current feature set and extensible for future enhancements!
