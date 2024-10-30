//
//  Theme.swift
//  Swiftly
//
//  Created by Patrick on 10/29/24.
//


import Foundation
import SwiftUI

struct Theme {
    // Store hex strings for colors
    let primaryColorHex: String
    let accentColorHex: String
    let backgroundColorHex: String
    
    // Computed properties to convert hex strings to Color
    var primaryColor: Color { Color(hex: primaryColorHex) }
    var accentColor: Color { Color(hex: accentColorHex) }
    var backgroundColor: Color { Color(hex: backgroundColorHex) }

    static let defaultTheme = Theme(primaryColorHex: "#0000FF", accentColorHex: "#FFA500", backgroundColorHex: "#E6E6FA")
    static let secondaryTheme = Theme(primaryColorHex: "#A70000", accentColorHex: "#FF5252", backgroundColorHex: "#FFBABA")
    // Add other themes here to access with Theme.name
}

struct ThemeEnvironmentKey: EnvironmentKey {
    public static let defaultValue: Theme = .defaultTheme
}

extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeEnvironmentKey.self] }
        set { self[ThemeEnvironmentKey.self] = newValue }
    }
}