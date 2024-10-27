//
//  ContentView.swift
//  Swiftly
//
//  Created by Patrick on 10/25/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var mainVM: MainViewModel
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                if authVM.authState == .unauthenticated {
                    AuthView()
                } else {
                    NavigationView()
                }
            }
        }
        .onAppear {
            setupInitialState()
        }
        .alert(item: $authVM.error) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("OK")) {
                    authVM.error = nil
                }
            )
        }
    }

    @ViewBuilder
    private func pageView(for page: Page) -> some View {
        switch page {
        case .splash:
            SplashView()
        case .auth:
            AuthView()
        case .onboarding:
            OnboardingView()
        case .home:
            HomeView()
        case .settings:
            SettingsView()
        }
    }

    private func setupInitialState() {
        if authVM.authState == .authenticated {
            mainVM.currentPage = .home
        } else {
            mainVM.currentPage = .onboarding
        }
    }
}

enum Page: String {
    case splash = "Splash"
    case auth = "Auth"
    case onboarding = "Onboarding"
    case home = "Home"
    case settings = "Settings"
}

#Preview {
    ContentView()
}
