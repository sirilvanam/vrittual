import SwiftUI
import SwiftData

struct AddHabitView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var selectedCategory: HabitCategory = .exercise
    @State private var selectedFrequency: TrackingFrequency = .daily
    @State private var targetCount = 1
    @State private var selectedIcon = "figure.run"
    @State private var selectedColor = Color.blue
    
    private var habitService: HabitService {
        HabitService(modelContext: modelContext)
    }
    
    private let categoryIcons: [HabitCategory: String] = [
        .calories: "fork.knife",
        .exercise: "figure.run",
        .hobby: "paintbrush",
        .waterIntake: "drop.fill",
        .travel: "airplane",
        .custom: "star.fill"
    ]
    
    private let availableIcons = [
        "figure.run", "figure.walk", "dumbbell", "bicycle",
        "paintbrush", "book.fill", "music.note", "camera.fill",
        "drop.fill", "cup.and.saucer", "leaf.fill",
        "airplane", "car.fill", "tram.fill",
        "checkmark.circle", "star.fill", "heart.fill", "flame.fill"
    ]
    
    private let availableColors: [Color] = [
        .blue, .green, .orange, .red, .purple, .pink, .yellow, .cyan, .indigo, .mint
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Habit Details")) {
                    TextField("Habit name", text: $name)
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(HabitCategory.allCases, id: \.self) { category in
                            Label(category.rawValue, systemImage: categoryIcons[category] ?? "star.fill")
                                .tag(category)
                        }
                    }
                }
                
                Section(header: Text("Tracking")) {
                    Picker("Frequency", selection: $selectedFrequency) {
                        ForEach(TrackingFrequency.allCases, id: \.self) { frequency in
                            Text(frequency.rawValue).tag(frequency)
                        }
                    }
                    
                    Stepper("Target: \(targetCount)x per \(selectedFrequency.rawValue.lowercased())", value: $targetCount, in: 1...50)
                }
                
                Section(header: Text("Appearance")) {
                    Picker("Icon", selection: $selectedIcon) {
                        ForEach(availableIcons, id: \.self) { icon in
                            Label("", systemImage: icon).tag(icon)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(availableColors, id: \.self) { color in
                                Circle()
                                    .fill(color)
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Circle()
                                            .stroke(selectedColor == color ? Color.primary : Color.clear, lineWidth: 3)
                                    )
                                    .onTapGesture {
                                        selectedColor = color
                                    }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Section(header: Text("Preview")) {
                    HStack {
                        Image(systemName: selectedIcon)
                            .foregroundColor(selectedColor)
                            .font(.title2)
                        
                        VStack(alignment: .leading) {
                            Text(name.isEmpty ? "Habit Name" : name)
                                .font(.headline)
                            Text("\(selectedFrequency.rawValue) • Target: \(targetCount)x")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Add Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveHabit()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func saveHabit() {
        let colorHex = selectedColor.toHex() ?? "#007AFF"
        
        let habit = Habit(
            name: name,
            category: selectedCategory,
            trackingFrequency: selectedFrequency,
            targetCount: targetCount,
            iconName: selectedIcon,
            color: colorHex
        )
        
        do {
            try habitService.addHabit(habit)
            dismiss()
        } catch {
            print("Error saving habit: \(error)")
        }
    }
}

// Color extension to convert to hex
extension Color {
    func toHex() -> String? {
        guard let components = UIColor(self).cgColor.components else { return nil }
        
        let r = components[0]
        let g = components.count > 1 ? components[1] : 0
        let b = components.count > 2 ? components[2] : 0
        
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
