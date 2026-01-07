import Foundation
import Combine

class UsageManager: ObservableObject {
    static let shared = UsageManager()

    @Published var messagesUsed: Int {
        didSet {
            saveUsage()
            notifyUpdate()
        }
    }

    @Published var messagesLimit: Int {
        didSet {
            saveUsage()
            notifyUpdate()
        }
    }

    @Published var lastUpdated: Date? {
        didSet {
            UserDefaults.standard.set(lastUpdated, forKey: "lastUpdated")
        }
    }

    var currentUsagePercentage: Double {
        guard messagesLimit > 0 else { return 0 }
        return (Double(messagesUsed) / Double(messagesLimit)) * 100
    }

    private init() {
        messagesUsed = UserDefaults.standard.integer(forKey: "messagesUsed")
        messagesLimit = UserDefaults.standard.object(forKey: "messagesLimit") as? Int ?? 100
        lastUpdated = UserDefaults.standard.object(forKey: "lastUpdated") as? Date
    }

    func updateUsage(used: Int, limit: Int) {
        messagesUsed = used
        messagesLimit = limit
        lastUpdated = Date()
    }

    private func saveUsage() {
        UserDefaults.standard.set(messagesUsed, forKey: "messagesUsed")
        UserDefaults.standard.set(messagesLimit, forKey: "messagesLimit")
    }

    private func notifyUpdate() {
        NotificationCenter.default.post(name: NSNotification.Name("UsageDidUpdate"), object: nil)
    }

    func resetUsage() {
        messagesUsed = 0
        messagesLimit = 100
        lastUpdated = nil
    }
}
