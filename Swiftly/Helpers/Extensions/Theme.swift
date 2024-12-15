import Foundation
import SwiftUI

// MARK: - Theme Mode

enum ThemeMode {
    case system
    case light
    case dark
    case custom(ThemeColors)
}

// MARK: - Theme Colors

struct ThemeColors: Codable {
    let primary: String
    let secondary: String
    let accent: String
    let muted: String
    let fill: String
    let background: String

    var primaryColor: Color { Color(hex: primary) }
    var secondaryColor: Color { Color(hex: secondary) }
    var accentColor: Color { Color(hex: accent) }
    var mutedColor: Color { Color(hex: muted) }
    var fillColor: Color { Color(hex: fill) }
    var backgroundColor: Color { Color(hex: background) }

    // Predefined themes
    static let light = ThemeColors(
        primary: "#0a0a0a",
        secondary: "#737373",
        accent: "#a3a3a3",
        muted: "#d4d4d4",
        fill: "#fafafa",
        background: "#f5f5f5"
        // background: "#FF0000"
    )

    static let dark = ThemeColors(
        primary: "#fafafa",
        secondary: "#737373",
        accent: "#525252",
        muted: "#262626",
        fill: "#171717",
        background: "#0a0a0a"
        // background: "#FF0000"
    )
}

// MARK: - Theme Manager

class ThemeManager: ObservableObject {
    @Published var currentThemeMode: ThemeMode = .system
    @AppStorage("savedThemeMode") private var savedThemeMode: String = "system"

    init() {
        // Restore saved theme mode
        switch savedThemeMode {
        case "light":
            currentThemeMode = .light
        case "dark":
            currentThemeMode = .dark
        case "system":
            currentThemeMode = .system
        default:
            if let themeData = UserDefaults.standard.data(forKey: "customTheme"),
               let decodedTheme = try? JSONDecoder().decode(ThemeColors.self, from: themeData)
            {
                currentThemeMode = .custom(decodedTheme)
            } else {
                currentThemeMode = .system
            }
        }
    }

    func setThemeMode(_ mode: ThemeMode) {
        currentThemeMode = mode
        switch mode {
        case .system:
            savedThemeMode = "system"
        case .light:
            savedThemeMode = "light"
        case .dark:
            savedThemeMode = "dark"
        case let .custom(colors):
            savedThemeMode = "custom"
            if let encoded = try? JSONEncoder().encode(colors) {
                UserDefaults.standard.set(encoded, forKey: "customTheme")
            }
        }
    }

    func getCurrentTheme(for colorScheme: ColorScheme) -> ThemeColors {
        switch currentThemeMode {
        case .system:
            return colorScheme == .dark ? .dark : .light
        case .light:
            return .light
        case .dark:
            return .dark
        case let .custom(colors):
            return colors
        }
    }
}

// MARK: - Environment Values

struct ThemeEnvironmentKey: EnvironmentKey {
    static let defaultValue: ThemeColors = .light
}

extension EnvironmentValues {
    var theme: ThemeColors {
        get { self[ThemeEnvironmentKey.self] }
        set { self[ThemeEnvironmentKey.self] = newValue }
    }
}

// MARK: - Theme Modifier

struct ThemeModifier: ViewModifier {
    @ObservedObject var themeManager: ThemeManager
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .environment(\.theme, themeManager.getCurrentTheme(for: colorScheme))
    }
}

extension View {
    func withTheme(_ themeManager: ThemeManager) -> some View {
        modifier(ThemeModifier(themeManager: themeManager))
    }
}
