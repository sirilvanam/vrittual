# Future Enhancements and TODOs

## Code Quality Improvements

### Type Safety
- [ ] Replace `entryType` string with enum:
  ```swift
  enum EntryType: String, CaseIterable {
      case ingredient
      case recipe
  }
  ```
- [ ] Replace `mealType` string with enum:
  ```swift
  enum MealType: String, CaseIterable {
      case breakfast
      case lunch
      case dinner
      case snack
  }
  ```
- [ ] Update models to use these enums instead of String
- [ ] Update service methods to accept enums
- [ ] Update views to use enums

### Code Organization
- [ ] Extract meal type constants to shared location
- [ ] Create a `Constants.swift` file for app-wide constants
- [ ] Consolidate meal type ordering logic

## Feature Enhancements

### Data & Storage
- [ ] Add edit functionality for calorie entries
- [ ] Add custom serving size support
- [ ] Add portion multipliers (e.g., 0.5x, 2x servings)
- [ ] Add favorites/recent items feature
- [ ] Add data export (CSV, JSON)
- [ ] Add data import functionality

### Tracking & Analytics
- [ ] Add weekly statistics view
- [ ] Add monthly statistics view
- [ ] Add nutritional macros (protein, carbs, fats, fiber)
- [ ] Add water intake tracking
- [ ] Add weight tracking
- [ ] Add progress charts and graphs
- [ ] Add streak tracking
- [ ] Add goal achievement badges

### UI/UX Improvements
- [ ] Add dark mode optimization
- [ ] Add custom themes
- [ ] Add haptic feedback
- [ ] Add pull-to-refresh
- [ ] Add empty state illustrations
- [ ] Add onboarding flow
- [ ] Add tutorial tooltips
- [ ] Improve iPad layout

### Advanced Features
- [ ] Barcode scanning for packaged foods
- [ ] Photo logging with AI recognition
- [ ] Integration with nutrition databases (USDA, etc.)
- [ ] Apple Health integration
- [ ] HealthKit data sync
- [ ] Apple Watch app
- [ ] Home screen widgets
- [ ] Lock screen widgets
- [ ] Siri shortcuts
- [ ] Meal planning feature
- [ ] Recipe creation wizard
- [ ] Social features (share meals, recipes)

### Backend & Sync
- [ ] Backend API for cloud sync
- [ ] User authentication
- [ ] Multi-device sync
- [ ] Recipe sharing community
- [ ] Backup and restore
- [ ] Cross-platform support

### Testing
- [ ] Unit tests for all service methods
- [ ] Integration tests for data persistence
- [ ] UI tests for main user flows
- [ ] Performance tests for large datasets
- [ ] Accessibility tests
- [ ] Localization tests

### Documentation
- [ ] Add inline code documentation
- [ ] Create API documentation
- [ ] Add video tutorials
- [ ] Create user manual
- [ ] Add troubleshooting guide

### Performance
- [ ] Add pagination for large lists
- [ ] Implement search result caching
- [ ] Optimize image loading (if adding photos)
- [ ] Add background sync
- [ ] Implement data compression

### Accessibility
- [ ] Full VoiceOver support verification
- [ ] Support for all Dynamic Type sizes
- [ ] High contrast mode support
- [ ] Reduce motion support
- [ ] Add audio feedback options

### Localization
- [ ] Add support for multiple languages
- [ ] Localize all strings
- [ ] Support for different date formats
- [ ] Support for different measurement units (metric/imperial)

## Bug Fixes & Edge Cases
- [ ] Handle network connectivity issues
- [ ] Handle low storage situations
- [ ] Improve error messages
- [ ] Add proper error logging
- [ ] Handle large datasets gracefully
- [ ] Add input validation improvements
- [ ] Test with extreme values

## Developer Experience
- [ ] Add SwiftLint configuration
- [ ] Add commit hooks
- [ ] Set up CI/CD pipeline
- [ ] Add automated testing
- [ ] Create development environment setup script
- [ ] Add code coverage tracking

## Security & Privacy
- [ ] Add data encryption at rest
- [ ] Implement secure data export
- [ ] Add privacy policy
- [ ] Implement data deletion feature
- [ ] Add biometric authentication option
- [ ] Audit third-party dependencies

---

**Priority Levels:**
- **High**: Type safety enums, edit functionality, export data
- **Medium**: Weekly stats, macros tracking, Apple Health
- **Low**: Social features, backend sync, localization

**Next Sprint Candidates:**
1. Type safety improvements (enums)
2. Edit entry functionality
3. Weekly statistics view
4. Export data feature
5. Apple Health integration
