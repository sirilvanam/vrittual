import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var calorieEntries: [CalorieEntry]
    @Query(filter: #Predicate<DailyGoal> { $0.isActive }) private var activeGoals: [DailyGoal]
    
    @State private var showingAddEntry = false
    @State private var selectedDate = Date()
    
    private var calorieService: CalorieService {
        CalorieService(modelContext: modelContext)
    }
    
    private var todayEntries: [CalorieEntry] {
        let calendar = Calendar.current
        return calorieEntries.filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
    }
    
    private var totalCaloriesToday: Double {
        todayEntries.reduce(0) { $0 + $1.calories }
    }
    
    private var dailyGoal: Double {
        activeGoals.first?.targetCalories ?? 2000
    }
    
    private var remainingCalories: Double {
        dailyGoal - totalCaloriesToday
    }
    
    private var progressPercentage: Double {
        min(totalCaloriesToday / dailyGoal, 1.0)
    }
    
    private var entriesHeaderText: String {
        if Calendar.current.isDateInToday(selectedDate) {
            return "Today's Entries"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return "\(formatter.string(from: selectedDate))'s Entries"
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Date Picker
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    
                    // Calorie Progress Card
                    VStack(spacing: 16) {
                        Text("Daily Calorie Goal")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        ZStack {
                            Circle()
                                .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                            
                            Circle()
                                .trim(from: 0, to: progressPercentage)
                                .stroke(
                                    remainingCalories >= 0 ? Color.green : Color.red,
                                    style: StrokeStyle(lineWidth: 20, lineCap: .round)
                                )
                                .rotationEffect(.degrees(-90))
                                .animation(.easeInOut, value: progressPercentage)
                            
                            VStack(spacing: 8) {
                                Text("\(Int(totalCaloriesToday))")
                                    .font(.system(size: 48, weight: .bold))
                                Text("of \(Int(dailyGoal)) cal")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(width: 220, height: 220)
                        .padding()
                        
                        HStack(spacing: 40) {
                            VStack {
                                Text("Remaining")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(Int(remainingCalories))")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(remainingCalories >= 0 ? .green : .red)
                            }
                            
                            Divider()
                                .frame(height: 40)
                            
                            VStack {
                                Text("Goal")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(Int(dailyGoal))")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.1), radius: 10)
                    
                    // Today's Entries
                    VStack(alignment: .leading, spacing: 12) {
                        Text(entriesHeaderText)
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if todayEntries.isEmpty {
                            Text("No entries yet today")
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            ForEach(groupedEntries, id: \.key) { mealType, entries in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(mealType.capitalized)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal)
                                    
                                    ForEach(entries) { entry in
                                        EntryRow(entry: entry, onDelete: {
                                            try? calorieService.deleteEntry(entry)
                                        })
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                }
                .padding()
            }
            .navigationTitle("Calorie Tracker")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddEntry = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $showingAddEntry) {
                AddCalorieEntryView(selectedDate: selectedDate)
            }
        }
    }
    
    private var groupedEntries: [(key: String, value: [CalorieEntry])] {
        let grouped = Dictionary(grouping: todayEntries) { $0.mealType }
        let order = ["breakfast", "lunch", "dinner", "snack"]
        return order.compactMap { mealType in
            guard let entries = grouped[mealType] else { return nil }
            return (key: mealType, value: entries)
        }
    }
}

struct EntryRow: View {
    let entry: CalorieEntry
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.name)
                    .font(.body)
                Text(entry.entryType.capitalized)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(Int(entry.calories)) cal")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}
