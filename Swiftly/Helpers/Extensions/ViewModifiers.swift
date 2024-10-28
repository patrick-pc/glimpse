//
//  ViewModifiers.swift
//  Swiftly
//
//  Created by Patrick on 10/28/24.
//

import SwiftUI

struct RoundedFontModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .regular, design: .rounded))
    }
}

extension View {
    func roundedFont() -> some View {
        self.modifier(RoundedFontModifier())
    }
}
