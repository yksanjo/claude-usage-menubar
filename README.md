# Claude Usage Menu Bar App

A native macOS menu bar app to track your Claude.ai usage in real-time.

## Features

- **Menu Bar Display**: Shows your current Claude usage percentage at a glance
- **Usage Stats**: View detailed stats on messages used vs. monthly limit
- **Color-Coded Progress**: Green, orange, or red indicators based on usage
- **Manual Updates**: Easy interface to input your current usage from Claude.ai
- **Quick Access**: Direct link to Claude.ai settings page
- **Persistent Storage**: Remembers your usage data between app launches

## Setup Instructions

### Prerequisites

1. **Install Xcode**
   - Open the App Store
   - Search for "Xcode"
   - Click "Get" or "Install"
   - Wait for installation to complete (this may take 10-30 minutes)

2. **Open Xcode Command Line Tools**
   - After Xcode installs, open Terminal
   - Run: `xcode-select --install`
   - Follow the prompts

### Building the App

1. **Open Xcode**
   - Launch Xcode from Applications or Spotlight

2. **Create New Project**
   - Click "Create New Project" or go to File > New > Project
   - Select **macOS** tab at the top
   - Choose **App** template
   - Click **Next**

3. **Configure Project**
   - **Product Name**: `ClaudeUsageMenuBar`
   - **Team**: Select your Apple ID (or leave as "None" for local development)
   - **Organization Identifier**: `com.yourname` (or use default)
   - **Interface**: **SwiftUI**
   - **Language**: **Swift**
   - **Uncheck** "Include Tests"
   - Click **Next**

4. **Choose Location**
   - Navigate to your home directory (`/Users/yoshikondo/`)
   - **IMPORTANT**: When saving, check "Delete existing folder" if prompted (we'll replace it with our code)
   - Click **Create**

5. **Replace Generated Files**
   - In Xcode's left sidebar (Project Navigator), you'll see the project structure
   - **Delete** the following auto-generated files (right-click > Delete > Move to Trash):
     - `ContentView.swift` (we'll replace it)
     - `ClaudeUsageMenuBarApp.swift` (we'll replace it)

6. **Add Our Files**
   - In Finder, navigate to `/Users/yoshikondo/ClaudeUsageMenuBar/ClaudeUsageMenuBar/`
   - Drag these files from Finder into Xcode's Project Navigator (onto "ClaudeUsageMenuBar" folder):
     - `ClaudeUsageMenuBarApp.swift`
     - `StatusBarController.swift`
     - `UsageManager.swift`
     - `ContentView.swift`
   - When prompted, ensure:
     - ✓ "Copy items if needed" is **checked**
     - ✓ "Add to targets: ClaudeUsageMenuBar" is **checked**
     - Click **Finish**

7. **Update Info.plist**
   - In Project Navigator, click on the **blue project icon** at the top
   - Select **ClaudeUsageMenuBar** target (under TARGETS)
   - Go to **Info** tab
   - Under "Custom macOS Application Target Properties", find or add:
     - **Key**: `Application is agent (UIElement)` or `LSUIElement`
     - **Type**: Boolean
     - **Value**: YES
   - This makes the app menu-bar only (no dock icon)

8. **Build and Run**
   - Press **Cmd + R** or click the **Play** button (▶) in the top toolbar
   - The app will compile and launch
   - Look for the "Claude 0%" text in your menu bar (top-right area)
   - Click it to see the usage interface!

## How to Use

1. **First Time Setup**
   - Go to [claude.ai/settings/usage](https://claude.ai/settings/usage)
   - Note your "Messages Used" and "Monthly Limit" numbers

2. **Update Usage in App**
   - Click the "Claude X%" text in your menu bar
   - Click **"Update Usage"** button
   - Enter your messages used and limit
   - Click **"Save"**

3. **Monitor Your Usage**
   - The menu bar will show your current usage percentage
   - Color changes:
     - **Green**: 0-69% (healthy)
     - **Orange**: 70-89% (getting high)
     - **Red**: 90-100% (nearly exhausted)

4. **Quick Actions**
   - **Update Usage**: Refresh your stats
   - **Open Claude.ai Settings**: Direct link to usage page
   - **Quit**: Close the app

## Troubleshooting

### App doesn't appear in menu bar
- Make sure `LSUIElement` is set to YES in Info.plist
- Try restarting the app

### Build errors in Xcode
- Make sure all 4 Swift files are added to the project target
- Check that you're building for macOS (not iOS)
- Try cleaning the build: Product > Clean Build Folder (Cmd + Shift + K)

### "No Developer Account" warning
- You can ignore this for local development
- The app will still build and run on your Mac

## Future Enhancements

- Automatic refresh via API (when you get an API key)
- Notifications when approaching limit
- Usage history and trends
- Multiple account support

## Technical Details

- **Language**: Swift + SwiftUI
- **Minimum macOS**: 13.0 (Ventura)
- **Storage**: UserDefaults for persistence
- **Architecture**: Menu bar agent (no dock icon)

---

Built with SwiftUI for macOS
