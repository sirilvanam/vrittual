import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<DailyGoal> { $0.isActive }) private var activeGoals: [DailyGoal]
    
    @State private var targetCalories: String = ""
    @State private var showingSaved = false
    
    private var calorieService: CalorieService {
        CalorieService(modelContext: modelContext)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Daily Calorie Goal")) {
                HStack {
                    Text("Target Calories")
                    Spacer()
                    TextField("2000", text: $targetCalories)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 100)
                }
                
                Button("Save Goal") {
                    saveGoal()
                }
                .frame(maxWidth: .infinity)
                .disabled(targetCalories.isEmpty)
            }
            
            Section(header: Text("Current Goal")) {
                if let goal = activeGoals.first {
                    HStack {
                        Text("Daily Target")
                        Spacer()
                        Text("\(Int(goal.targetCalories)) calories")
                            .foregroundColor(.secondary)
                    }
                } else {
                    Text("No goal set. Default: 2000 calories")
                        .foregroundColor(.secondary)
                }
            }
            
            Section(header: Text("Data Management")) {
                NavigationLink("Manage Ingredients") {
                    ManageIngredientsView()
                }
                
                NavigationLink("Manage Recipes") {
                    ManageRecipesView()
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let goal = activeGoals.first {
                targetCalories = String(Int(goal.targetCalories))
            }
        }
        .alert("Goal Saved", isPresented: $showingSaved) {
            Button("OK", role: .cancel) { }
        }
    }
    
    private func saveGoal() {
        guard let calories = Double(targetCalories) else { return }
        try? calorieService.setDailyGoal(targetCalories: calories)
        showingSaved = true
    }
}
