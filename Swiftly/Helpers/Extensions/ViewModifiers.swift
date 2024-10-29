//
//  ViewModifiers.swift
//  Swiftly
//
//  Created by Patrick on 10/28/24.
//

import SwiftUI

struct RoundedFontModifier: ViewModifier {
    init() {
        var titleFont = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleFont = UIFont(
            descriptor:
            titleFont.fontDescriptor
                .withDesign(.rounded)?
                .withSymbolicTraits(.traitBold)
                ??
                titleFont.fontDescriptor, /// Return the normal title if customization failed
            size: titleFont.pointSize
        )

        /// Set the rounded font
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: titleFont]
    }

    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .regular, design: .rounded))
    }
}

extension View {
    func roundedFont() -> some View {
        modifier(RoundedFontModifier())
    }
}
