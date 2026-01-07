import SwiftUI

struct ContentView: View {
    @ObservedObject var usageManager = UsageManager.shared
    @State private var showingUpdateSheet = false
    @State private var tempUsed = ""
    @State private var tempLimit = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.blue)
                Text("Claude Usage")
                    .font(.headline)
            }
            .padding(.top, 8)

            Divider()

            // Usage Stats
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Messages Used:")
                    Spacer()
                    Text("\(usageManager.messagesUsed)")
                        .bold()
                }

                HStack {
                    Text("Monthly Limit:")
                    Spacer()
                    Text("\(usageManager.messagesLimit)")
                        .bold()
                }

                // Progress Bar
                ProgressView(value: usageManager.currentUsagePercentage, total: 100)
                    .progressViewStyle(.linear)
                    .tint(progressColor)

                HStack {
                    Text("Usage:")
                    Spacer()
                    Text(String(format: "%.1f%%", usageManager.currentUsagePercentage))
                        .bold()
                        .foregroundColor(progressColor)
                }
            }

            if let lastUpdated = usageManager.lastUpdated {
                Text("Last updated: \(formatDate(lastUpdated))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Divider()

            // Buttons
            VStack(spacing: 8) {
                Button(action: { showingUpdateSheet = true }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Update Usage")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Button(action: openClaudeSettings) {
                    HStack {
                        Image(systemName: "safari")
                        Text("Open Claude.ai Settings")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button(action: quitApp) {
                    HStack {
                        Image(systemName: "xmark.circle")
                        Text("Quit")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .frame(width: 300)
        .sheet(isPresented: $showingUpdateSheet) {
            UpdateUsageView(isPresented: $showingUpdateSheet)
        }
    }

    private var progressColor: Color {
        let percentage = usageManager.currentUsagePercentage
        if percentage >= 90 { return .red }
        if percentage >= 70 { return .orange }
        return .green
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }

    private func openClaudeSettings() {
        if let url = URL(string: "https://claude.ai/settings/usage") {
            NSWorkspace.shared.open(url)
        }
    }

    private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}

struct UpdateUsageView: View {
    @Binding var isPresented: Bool
    @ObservedObject var usageManager = UsageManager.shared

    @State private var usedInput: String
    @State private var limitInput: String

    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        let manager = UsageManager.shared
        self._usedInput = State(initialValue: "\(manager.messagesUsed)")
        self._limitInput = State(initialValue: "\(manager.messagesLimit)")
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Update Claude Usage")
                .font(.title2)
                .bold()

            VStack(alignment: .leading, spacing: 12) {
                Text("Enter your current usage from Claude.ai settings:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                HStack {
                    Text("Messages Used:")
                    TextField("0", text: $usedInput)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 100)
                }

                HStack {
                    Text("Monthly Limit:")
                    TextField("100", text: $limitInput)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 100)
                }
            }

            HStack(spacing: 12) {
                Button("Cancel") {
                    isPresented = false
                }
                .buttonStyle(.bordered)

                Button("Save") {
                    saveUsage()
                }
                .buttonStyle(.borderedProminent)
                .disabled(!isValidInput)
            }
        }
        .padding(24)
        .frame(width: 400)
    }

    private var isValidInput: Bool {
        guard let used = Int(usedInput),
              let limit = Int(limitInput),
              used >= 0,
              limit > 0 else {
            return false
        }
        return true
    }

    private func saveUsage() {
        guard let used = Int(usedInput),
              let limit = Int(limitInput) else {
            return
        }

        usageManager.updateUsage(used: used, limit: limit)
        isPresented = false
    }
}
