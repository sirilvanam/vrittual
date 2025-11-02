# Habitly App Features & UI Overview

## 📱 Main Dashboard Screen

The dashboard is the heart of the Habitly app, providing an at-a-glance view of your daily calorie tracking progress.

### Key UI Elements:

#### 1. **Date Picker**
- Compact date picker at the top of the screen
- Allows users to view and track calories for any day
- Defaults to today's date
- Gray background for clear visibility

#### 2. **Calorie Progress Circle**
- Large, prominent circular progress indicator (220x220 points)
- Shows calorie consumption as a percentage of daily goal
- **Color Coding:**
  - Green: When under the daily goal
  - Red: When exceeding the daily goal
- Displays current calories consumed in large, bold text (48pt)
- Shows total goal beneath in smaller text
- Animated transitions for smooth visual feedback

#### 3. **Statistics Row**
- Two key metrics side by side:
  - **Remaining Calories:** How many calories left for the day
  - **Goal:** Total daily calorie target
- Color-coded remaining calories (green/red)
- Separated by a vertical divider

#### 4. **Today's Entries List**
- Organized by meal type: Breakfast, Lunch, Dinner, Snack
- Each entry shows:
  - Item name
  - Type (Ingredient or Recipe)
  - Calorie count
  - Delete button (trash icon)
- Gray card-style backgrounds for each entry
- Empty state message when no entries exist

#### 5. **Navigation Bar**
- **Left:** Settings gear icon
- **Title:** "Calorie Tracker"
- **Right:** Plus button to add new entries

---

## ➕ Add Entry Screen

Streamlined interface for quickly logging meals.

### Key Features:

#### 1. **Meal Type Selector**
- Segmented control with 4 options:
  - Breakfast
  - Lunch
  - Dinner
  - Snack
- Always visible at the top

#### 2. **Source Tabs**
- Toggle between "Ingredients" and "Recipes"
- Segmented control style
- Easy switching between databases

#### 3. **Search Bar**
- Magnifying glass icon on the left
- Real-time filtering of items
- Clear button (X) appears when typing
- Gray background for distinction

#### 4. **Item Lists**
- Scrollable list of all ingredients or recipes
- Each item card shows:
  - **For Ingredients:**
    - Name
    - Serving size and category
    - Calorie count
    - Plus icon to add
  - **For Recipes:**
    - Name
    - Number of servings
    - Calories per serving
    - Total calories
    - Plus icon to add
- One-tap addition to daily log
- Automatic dismissal after adding

---

## ⚙️ Settings Screen

Configuration and data management hub.

### Sections:

#### 1. **Daily Calorie Goal**
- Text field to enter target calories
- Number pad keyboard for easy input
- "Save Goal" button
- Confirmation alert when saved

#### 2. **Current Goal Display**
- Shows active daily target
- Displays default (2000 cal) if none set
- Gray secondary text for clarity

#### 3. **Data Management**
- Navigation links to:
  - Manage Ingredients
  - Manage Recipes
- Standard iOS navigation style

---

## 🥗 Manage Ingredients Screen

Full CRUD operations for the ingredient database.

### Features:

- **List View:**
  - Shows all ingredients alphabetically
  - Name in bold
  - Calorie count, serving size, and category
  - Swipe-to-delete functionality
  
- **Add Ingredient Form:**
  - Name field
  - Calories per serving (decimal pad)
  - Serving size (text)
  - Category picker with preset options:
    - Fruit
    - Vegetable
    - Protein
    - Grain
    - Dairy
    - Snack
    - Beverage
    - Other
  - Save/Cancel buttons in navigation bar
  - Validation (all fields required)

---

## 🍳 Manage Recipes Screen

Full CRUD operations for the recipe database.

### Features:

- **List View:**
  - Shows all recipes alphabetically
  - Name in bold
  - Total calories, servings, and per-serving calories
  - Swipe-to-delete functionality

- **Add Recipe Form:**
  - Recipe name field
  - Total calories (decimal pad)
  - Number of servings (number pad)
  - Dynamic ingredient list:
    - Start with one field
    - Add/remove ingredients dynamically
    - Plus/minus buttons
  - Instructions text editor (multi-line)
  - Save/Cancel buttons
  - Validation (name, calories, servings, at least one ingredient required)

---

## 🎨 Design Principles

### Color Scheme:
- **Primary:** System blue for interactive elements
- **Success:** Green for under-goal status
- **Warning:** Red for over-goal status
- **Neutral:** System gray backgrounds for cards
- **Text:** System primary and secondary colors

### Typography:
- **Large Display:** 48pt bold for main calorie number
- **Headlines:** System headline font
- **Body:** System body font
- **Captions:** System caption font for secondary info

### Layout:
- **Cards:** Rounded corners (8-16pt radius)
- **Spacing:** Consistent padding (12-20pts)
- **Shadows:** Subtle drop shadows on main cards
- **Scrollable:** All list views scroll smoothly

### Interaction:
- **Buttons:** Standard iOS button styles
- **Navigation:** Native NavigationStack behavior
- **Modals:** Sheet presentation for forms
- **Alerts:** System alerts for confirmations
- **Animations:** Smooth transitions on progress updates

---

## 📊 Data Flow

### Adding a Calorie Entry:
1. User taps + button
2. Selects meal type
3. Chooses Ingredients or Recipes tab
4. Searches if needed
5. Taps item to add
6. Entry is saved to SwiftData
7. Dashboard updates immediately
8. Sheet dismisses automatically

### Viewing Progress:
1. Dashboard loads current date
2. Queries all entries for selected date
3. Calculates total calories
4. Compares to active goal
5. Updates progress circle
6. Groups entries by meal type
7. Displays organized list

### Managing Goal:
1. User navigates to Settings
2. Enters new target
3. Taps Save
4. Service deactivates old goals
5. Creates new active goal
6. Shows confirmation
7. Dashboard reflects new goal

---

## 🔧 Technical Implementation

### SwiftData Models:
- **@Model** macro for all data types
- Automatic persistence
- iCloud sync support (if enabled)
- Query API for fetching

### SwiftUI Views:
- Declarative UI
- State management with @State
- Environment objects for context
- @Query for reactive data

### Architecture:
- MVVM-inspired structure
- Service layer for business logic
- Separation of concerns
- Reusable components

---

## 🚀 Performance Optimizations

- **Lazy Loading:** LazyVStack for long lists
- **Query Predicates:** Efficient filtering at database level
- **Minimal Re-renders:** Targeted state updates
- **SwiftData Caching:** Automatic data caching
- **Search Debouncing:** Real-time but efficient filtering

---

## ♿ Accessibility

- **VoiceOver:** All elements properly labeled
- **Dynamic Type:** Respects user font size preferences
- **Color Contrast:** Meets WCAG guidelines
- **Keyboard Navigation:** Full keyboard support
- **Reduced Motion:** Respects accessibility settings

---

## 🎯 User Experience Highlights

1. **One-Tap Entry:** Adding food takes just 2-3 taps
2. **Visual Feedback:** Clear progress indication
3. **Smart Defaults:** Sensible starting values
4. **Forgiving UX:** Easy to correct mistakes
5. **No Learning Curve:** Intuitive iOS patterns
6. **Fast Search:** Quick filtering of databases
7. **Organized Display:** Logical grouping by meal
8. **Persistent Data:** Never lose your entries

---

This comprehensive feature set makes Habitly a powerful yet simple calorie tracking solution for iPhone users!
