import SwiftUI
import SwiftData

struct HabitsDashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Habit> { $0.isActive }) private var habits: [Habit]
    
    @State private var showingAddHabit = false
    @State private var selectedDate = Date()
    @State private var statistics: [HabitStatistics] = []
    
    private var habitService: HabitService {
        HabitService(modelContext: modelContext)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Overall Summary Card
                    overallSummaryCard
                    
                    // Individual Habit Cards
                    ForEach(statistics, id: \.habitId) { stat in
                        if let habit = habits.first(where: { $0.id == stat.habitId }) {
                            NavigationLink(destination: HabitDetailView(habit: habit)) {
                                HabitCard(statistic: stat, onToggle: {
                                    toggleHabitCompletion(for: stat.habitId)
                                })
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    if habits.isEmpty {
                        emptyStateView
                    }
                }
                .padding()
            }
            .navigationTitle("My Habits")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddHabit = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: DashboardView()) {
                        Image(systemName: "fork.knife")
                            .foregroundColor(.orange)
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView()
            }
            .onAppear {
                loadStatistics()
            }
            .refreshable {
                loadStatistics()
            }
        }
    }
    
    private var overallSummaryCard: some View {
        VStack(spacing: 16) {
            Text("Today's Progress")
                .font(.headline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 30) {
                VStack {
                    Text("\(completedCount)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.green)
                    Text("Completed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                    .frame(height: 50)
                
                VStack {
                    Text("\(missedCount)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.red)
                    Text("Missed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                    .frame(height: 50)
                
                VStack {
                    Text("\(overallCompletionPercentage)%")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.blue)
                    Text("Success Rate")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "list.bullet.clipboard")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No Habits Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Tap the + button to add your first habit")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }
    
    private var completedCount: Int {
        statistics.filter { $0.isOnTrack }.count
    }
    
    private var missedCount: Int {
        statistics.count - completedCount
    }
    
    private var overallCompletionPercentage: Int {
        guard !statistics.isEmpty else { return 0 }
        let totalRate = statistics.reduce(0.0) { $0 + $1.completionRate }
        return Int((totalRate / Double(statistics.count)) * 100)
    }
    
    private func loadStatistics() {
        statistics = (try? habitService.getAllHabitStatistics(forDate: selectedDate)) ?? []
    }
    
    private func toggleHabitCompletion(for habitId: UUID) {
        guard let habit = habits.first(where: { $0.id == habitId }) else { return }
        
        do {
            let existingLog = try habitService.getLogForDate(habitId: habitId, date: selectedDate)
            let newCompletedState = !(existingLog?.completed ?? false)
            
            try habitService.logHabit(
                habitId: habitId,
                date: selectedDate,
                completed: newCompletedState
            )
            
            loadStatistics()
        } catch {
            print("Error toggling habit: \(error)")
        }
    }
}

struct HabitCard: View {
    let statistic: HabitStatistics
    let onToggle: () -> Void
    
    private var progressPercentage: Double {
        min(statistic.completionRate, 1.0)
    }
    
    private var statusColor: Color {
        statistic.isOnTrack ? .green : .orange
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(statistic.habitName)
                        .font(.headline)
                    
                    Text("\(statistic.frequency.rawValue) • Target: \(statistic.targetCount)x")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: onToggle) {
                    Image(systemName: statistic.isOnTrack ? "checkmark.circle.fill" : "circle")
                        .font(.title)
                        .foregroundColor(statistic.isOnTrack ? .green : .gray)
                }
                .buttonStyle(.plain)
            }
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(statusColor)
                        .frame(width: geometry.size.width * progressPercentage, height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
            
            HStack {
                Text("\(statistic.completedCount) / \(statistic.targetCount) completed")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if statistic.missedCount > 0 {
                    Text("\(statistic.missedCount) missed")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}


