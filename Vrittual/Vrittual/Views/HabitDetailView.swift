import SwiftUI
import SwiftData

struct HabitDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let habit: Habit
    
    @State private var logs: [HabitLog] = []
    @State private var showingAddLog = false
    
    private var habitService: HabitService {
        HabitService(modelContext: modelContext)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Statistics Card
                statisticsCard
                
                // Recent Logs
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent Activity")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if logs.isEmpty {
                        Text("No activity yet")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        ForEach(logs) { log in
                            LogRow(log: log)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(habit.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddLog = true }) {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
        .sheet(isPresented: $showingAddLog) {
            AddLogView(habit: habit)
        }
        .onAppear {
            loadLogs()
        }
    }
    
    private var statisticsCard: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: habit.iconName)
                    .font(.system(size: 40))
                    .foregroundColor(Color(hex: habit.color))
                
                VStack(alignment: .leading) {
                    Text(habit.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(habit.categoryEnum.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            Divider()
            
            HStack(spacing: 30) {
                VStack {
                    Text("\(completedCount)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text("Completed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    Text("\(missedCount)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    Text("Missed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    Text("\(streakCount)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    Text("Streak")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private var completedCount: Int {
        logs.filter { $0.completed }.count
    }
    
    private var missedCount: Int {
        logs.filter { !$0.completed }.count
    }
    
    private var streakCount: Int {
        // Calculate current streak
        let sortedLogs = logs.sorted { $0.date > $1.date }
        var streak = 0
        for log in sortedLogs {
            if log.completed {
                streak += 1
            } else {
                break
            }
        }
        return streak
    }
    
    private func loadLogs() {
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        logs = (try? habitService.getLogsForHabit(habitId: habit.id, startDate: thirtyDaysAgo, endDate: Date())) ?? []
    }
}

struct LogRow: View {
    let log: HabitLog
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        HStack {
            Image(systemName: log.completed ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(log.completed ? .green : .red)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(dateFormatter.string(from: log.date))
                    .font(.body)
                
                if !log.notes.isEmpty {
                    Text(log.notes)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let value = log.value {
                    Text("Value: \(String(format: "%.1f", value))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Text(log.completed ? "Done" : "Missed")
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(log.completed ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                .foregroundColor(log.completed ? .green : .red)
                .cornerRadius(8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct AddLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let habit: Habit
    
    @State private var selectedDate = Date()
    @State private var completed = true
    @State private var notes = ""
    @State private var value: String = ""
    
    private var habitService: HabitService {
        HabitService(modelContext: modelContext)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Log Details")) {
                    DatePicker("Date", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                    
                    Toggle("Completed", isOn: $completed)
                }
                
                Section(header: Text("Optional")) {
                    TextField("Notes", text: $notes)
                    
                    TextField("Value (e.g., 8 glasses, 30 minutes)", text: $value)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Log Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveLog()
                    }
                }
            }
        }
    }
    
    private func saveLog() {
        let numericValue = Double(value)
        
        do {
            try habitService.logHabit(
                habitId: habit.id,
                date: selectedDate,
                completed: completed,
                notes: notes,
                value: numericValue
            )
            dismiss()
        } catch {
            print("Error saving log: \(error)")
        }
    }
}
