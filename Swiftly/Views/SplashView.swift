//
//  SplashView.swift
//  Swiftly
//
//  Created by Patrick on 10/25/24.
//

import SwiftUI

struct SplashView: View {
    @Environment(\.colorScheme) var colorScheme

    @State private var isActive = false

    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)

            Label("Swiftly", systemImage: "swift")
                .foregroundColor(foregroundColor)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }

    private var backgroundColor: Color {
        colorScheme == .dark ? .black : .white
    }

    private var foregroundColor: Color {
        colorScheme == .dark ? .white : .black
    }
}

#Preview {
    SplashView()
}
