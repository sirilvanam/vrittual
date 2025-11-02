# Contributing to Habitly

Thank you for your interest in contributing to Habitly! This document provides guidelines for contributing to the project.

## 🚀 Getting Started

### Prerequisites
- macOS with Xcode 15.0 or later
- iOS 17.0 SDK
- Basic knowledge of Swift and SwiftUI
- Familiarity with SwiftData (optional but helpful)

### Setting Up Development Environment

1. **Fork the Repository**
```bash
# Fork on GitHub, then clone your fork
git clone https://github.com/YOUR_USERNAME/habitly.git
cd habitly
```

2. **Open in Xcode**
```bash
cd Habitly
open Habitly.xcodeproj
```

3. **Build and Run**
- Select a simulator or device
- Press ⌘ + R to build and run
- The app should launch with sample data

## 📝 Code Style Guidelines

### Swift Style
We follow the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/) with these additions:

#### Naming Conventions
```swift
// Classes and Structs: PascalCase
class CalorieService { }
struct DashboardView: View { }

// Variables and Functions: camelCase
var totalCalories: Double
func addCalorieEntry() { }

// Constants: camelCase
let defaultGoal = 2000

// Private properties: prefix with underscore (optional)
private var _internalCache: [String: Any]
```

#### SwiftUI View Structure
```swift
struct MyView: View {
    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var showingSheet = false
    
    // MARK: - Computed Properties
    private var filteredItems: [Item] {
        // implementation
    }
    
    // MARK: - Body
    var body: some View {
        // implementation
    }
    
    // MARK: - Private Methods
    private func doSomething() {
        // implementation
    }
}
```

#### Model Structure
```swift
@Model
final class MyModel {
    var id: UUID
    var name: String
    var value: Double
    
    init(name: String, value: Double) {
        self.id = UUID()
        self.name = name
        self.value = value
    }
}
```

### File Organization
- **One type per file** (with exceptions for small, related types)
- **Group related files** in folders (Models, Views, Services)
- **Name files after their primary type** (e.g., `DashboardView.swift`)

### Comments
```swift
// Use comments sparingly - code should be self-documenting
// DO add comments for:
// - Complex algorithms
// - Non-obvious business logic
// - Public APIs

/// Documentation comments for public APIs
/// - Parameter name: Description of parameter
/// - Returns: Description of return value
func publicFunction(name: String) -> String {
    // Implementation
}
```

## 🧪 Testing Guidelines

### Writing Tests
- Write tests for all business logic in the Services layer
- Test edge cases and error conditions
- Use descriptive test names

```swift
@MainActor
func testAddCalorieEntry_WithValidData_SavesSuccessfully() throws {
    // Given
    let expectedCalories = 100.0
    
    // When
    try calorieService.addCalorieEntry(
        name: "Test Food",
        calories: expectedCalories,
        entryType: "ingredient",
        mealType: "breakfast"
    )
    
    // Then
    let entries = try calorieService.getCaloriesForDate(Date())
    XCTAssertEqual(entries.count, 1)
    XCTAssertEqual(entries.first?.calories, expectedCalories)
}
```

### Running Tests
```bash
# In Xcode
⌘ + U

# Or via command line
xcodebuild test -scheme Habitly -destination 'platform=iOS Simulator,name=iPhone 15'
```

## 🔄 Git Workflow

### Branch Naming
- `feature/description` - New features
- `fix/description` - Bug fixes
- `docs/description` - Documentation changes
- `refactor/description` - Code refactoring

### Commit Messages
Follow the [Conventional Commits](https://www.conventionalcommits.org/) format:

```
type(scope): subject

body (optional)

footer (optional)
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(dashboard): add weekly statistics view

fix(calorie-entry): correct meal type filtering

docs(readme): update installation instructions

refactor(service): extract common database operations
```

### Pull Request Process

1. **Create a Branch**
```bash
git checkout -b feature/your-feature-name
```

2. **Make Changes**
- Write code
- Add tests
- Update documentation

3. **Commit Changes**
```bash
git add .
git commit -m "feat(feature): add new feature"
```

4. **Push to Your Fork**
```bash
git push origin feature/your-feature-name
```

5. **Create Pull Request**
- Go to GitHub
- Click "New Pull Request"
- Fill in the template
- Request review

### Pull Request Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] New feature
- [ ] Bug fix
- [ ] Documentation update
- [ ] Refactoring

## Testing
- [ ] Tests added/updated
- [ ] All tests passing
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] No new warnings
```

## 🐛 Reporting Issues

### Bug Reports
Include:
- **Description**: Clear description of the bug
- **Steps to Reproduce**: Numbered steps
- **Expected Behavior**: What should happen
- **Actual Behavior**: What actually happens
- **Environment**: iOS version, device/simulator
- **Screenshots**: If applicable

**Template:**
```markdown
**Description**
Brief description of the bug

**Steps to Reproduce**
1. Open app
2. Navigate to...
3. Tap on...
4. See error

**Expected Behavior**
Should display...

**Actual Behavior**
Shows error...

**Environment**
- iOS: 17.0
- Device: iPhone 15 Simulator
- App Version: 1.0

**Screenshots**
[If applicable]
```

### Feature Requests
Include:
- **Problem**: What problem does this solve?
- **Solution**: Proposed solution
- **Alternatives**: Other solutions considered
- **Use Case**: How would you use this feature?

## 📁 Project Structure

```
Habitly/
├── Habitly/
│   ├── HabitlyApp.swift          # App entry point
│   ├── Models/                    # Data models
│   │   ├── Ingredient.swift
│   │   ├── Recipe.swift
│   │   ├── CalorieEntry.swift
│   │   └── DailyGoal.swift
│   ├── Views/                     # SwiftUI views
│   │   ├── DashboardView.swift
│   │   ├── AddCalorieEntryView.swift
│   │   ├── SettingsView.swift
│   │   ├── ManageIngredientsView.swift
│   │   └── ManageRecipesView.swift
│   ├── Services/                  # Business logic
│   │   ├── CalorieService.swift
│   │   └── SampleDataLoader.swift
│   └── Assets.xcassets/           # Assets
└── Documentation/                 # Markdown docs
```

## 🎯 Areas for Contribution

### Good First Issues
- Add more sample ingredients/recipes
- Improve error messages
- Add input validation
- Enhance accessibility labels
- Write additional tests

### Medium Complexity
- Add export to CSV functionality
- Implement weekly/monthly statistics
- Add nutritional macros tracking
- Implement meal planning
- Add custom serving sizes

### Advanced Features
- Backend API integration
- iCloud sync optimization
- Apple Health integration
- HealthKit data import
- Barcode scanning
- Photo logging
- Widget support
- Watch app

## 💡 Development Tips

### SwiftData Best Practices
```swift
// Use @Query for reactive data
@Query private var items: [Item]

// Use predicates for filtering
@Query(filter: #Predicate<Item> { $0.isActive })
private var activeItems: [Item]

// Use sort descriptors
@Query(sort: \Item.name) private var sortedItems: [Item]
```

### Performance Optimization
- Use `LazyVStack` for long lists
- Implement pagination for large datasets
- Use predicates to filter at database level
- Avoid unnecessary view re-renders

### Debugging
```swift
// Print to console
print("Debug: \(value)")

// Breakpoints in Xcode
// Set breakpoint on line, run in debug mode

// View hierarchy debugging
// Debug → View Debugging → Capture View Hierarchy
```

## 📚 Resources

### Learning Resources
- [Swift Documentation](https://swift.org/documentation/)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [SwiftData Documentation](https://developer.apple.com/documentation/swiftdata)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

### Community
- [Swift Forums](https://forums.swift.org/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/swift)
- [r/iOSProgramming](https://www.reddit.com/r/iOSProgramming/)

## ❓ Questions?

If you have questions:
1. Check existing issues
2. Review documentation
3. Ask in discussions
4. Create a new issue

## 📄 License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT License).

## 🙏 Thank You!

Every contribution helps make Habitly better for everyone. We appreciate your time and effort!

---

**Happy Coding! 🎉**
