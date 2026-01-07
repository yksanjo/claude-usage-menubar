import SwiftUI
import AppKit

class StatusBarController: NSObject {
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    private var usageManager = UsageManager.shared

    override init() {
        statusBar = NSStatusBar.system
        statusItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        popover = NSPopover()

        super.init()

        setupStatusItem()
        setupPopover()
        updateStatusBarDisplay()

        // Listen for usage updates
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateStatusBarDisplay),
            name: NSNotification.Name("UsageDidUpdate"),
            object: nil
        )
    }

    private func setupStatusItem() {
        if let button = statusItem.button {
            button.action = #selector(togglePopover)
            button.target = self
        }
    }

    private func setupPopover() {
        popover.contentSize = NSSize(width: 300, height: 200)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: ContentView())
    }

    @objc func updateStatusBarDisplay() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let usage = self.usageManager.currentUsagePercentage
            let statusText = String(format: "Claude %.0f%%", usage)
            self.statusItem.button?.title = statusText
        }
    }

    @objc func togglePopover() {
        if popover.isShown {
            closePopover()
        } else {
            showPopover()
        }
    }

    func showPopover() {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }

    func closePopover() {
        popover.performClose(nil)
    }
}
