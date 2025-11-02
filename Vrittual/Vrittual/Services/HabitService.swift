import Foundation
import SwiftData

@MainActor
class HabitService {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Habit Management
    
    func getAllHabits() throws -> [Habit] {
        let descriptor = FetchDescriptor<Habit>(
            predicate: #Predicate { $0.isActive },
            sortBy: [SortDescriptor(\.createdDate)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    func addHabit(_ habit: Habit) throws {
        modelContext.insert(habit)
        try modelContext.save()
    }
    
    func deleteHabit(_ habit: Habit) throws {
        habit.isActive = false
        try modelContext.save()
    }
    
    // MARK: - Habit Logging
    
    func logHabit(habitId: UUID, date: Date, completed: Bool, notes: String = "", value: Double? = nil) throws {
        // Check if log already exists for this habit on this date
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = #Predicate<HabitLog> { log in
            log.habitId == habitId && log.date >= startOfDay && log.date < endOfDay
        }
        let descriptor = FetchDescriptor<HabitLog>(predicate: predicate)
        let existingLogs = try modelContext.fetch(descriptor)
        
        if let existingLog = existingLogs.first {
            // Update existing log
            existingLog.completed = completed
            existingLog.notes = notes
            existingLog.value = value
        } else {
            // Create new log
            let log = HabitLog(habitId: habitId, date: date, completed: completed, notes: notes, value: value)
            modelContext.insert(log)
        }
        
        try modelContext.save()
    }
    
    func getLogsForHabit(habitId: UUID, startDate: Date, endDate: Date) throws -> [HabitLog] {
        let predicate = #Predicate<HabitLog> { log in
            log.habitId == habitId && log.date >= startDate && log.date < endDate
        }
        let descriptor = FetchDescriptor<HabitLog>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    func getLogForDate(habitId: UUID, date: Date) throws -> HabitLog? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = #Predicate<HabitLog> { log in
            log.habitId == habitId && log.date >= startOfDay && log.date < endOfDay
        }
        let descriptor = FetchDescriptor<HabitLog>(predicate: predicate)
        return try modelContext.fetch(descriptor).first
    }
    
    // MARK: - Statistics
    
    func getHabitStatistics(habit: Habit, forDate date: Date = Date()) throws -> HabitStatistics {
        let calendar = Calendar.current
        let frequency = habit.frequencyEnum
        
        // Calculate period start date
        let periodStart: Date
        switch frequency {
        case .daily:
            periodStart = calendar.startOfDay(for: date)
        case .weekly:
            periodStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)) ?? date
        case .biweekly:
            let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)) ?? date
            let weekNumber = calendar.component(.weekOfYear, from: date)
            let isOddWeek = weekNumber % 2 == 1
            periodStart = isOddWeek ? weekStart : calendar.date(byAdding: .day, value: -7, to: weekStart) ?? weekStart
        case .monthly:
            periodStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) ?? date
        }
        
        let periodEnd = calendar.date(byAdding: .day, value: frequency.daysCount, to: periodStart) ?? date
        
        let logs = try getLogsForHabit(habitId: habit.id, startDate: periodStart, endDate: periodEnd)
        let completedCount = logs.filter { $0.completed }.count
        let missedCount = logs.filter { !$0.completed }.count
        
        let completionRate = habit.targetCount > 0 ? Double(completedCount) / Double(habit.targetCount) : 0.0
        
        return HabitStatistics(
            habitId: habit.id,
            habitName: habit.name,
            frequency: frequency,
            targetCount: habit.targetCount,
            completedCount: completedCount,
            missedCount: missedCount,
            completionRate: completionRate,
            periodStart: periodStart,
            periodEnd: periodEnd
        )
    }
    
    func getAllHabitStatistics(forDate date: Date = Date()) throws -> [HabitStatistics] {
        let habits = try getAllHabits()
        return try habits.map { try getHabitStatistics(habit: $0, forDate: date) }
    }
}

struct HabitStatistics {
    let habitId: UUID
    let habitName: String
    let frequency: TrackingFrequency
    let targetCount: Int
    let completedCount: Int
    let missedCount: Int
    let completionRate: Double
    let periodStart: Date
    let periodEnd: Date
    
    var isOnTrack: Bool {
        completionRate >= 1.0
    }
    
    var remainingCount: Int {
        max(0, targetCount - completedCount)
    }
}
