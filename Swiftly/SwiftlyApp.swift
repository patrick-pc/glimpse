//
//  SwiftlyApp.swift
//  Swiftly
//
//  Created by Patrick on 10/25/24.
//

import FirebaseCore
import SwiftUI

@main
struct SwiftlyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var mainViewModel = MainViewModel()
    @State private var showSplash = true

    init() {
        setup()
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environmentObject(authViewModel)
                    .environmentObject(mainViewModel)

                if showSplash {
                    SplashView()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showSplash = false
                    }
                }
            }
        }
    }
}

private extension SwiftlyApp {
    func setup() {
        // Purchases.configure(withAPIKey: "")

        // Superwall.configure(apiKey: "")

        // Mixpanel.initialize(token: "", trackAutomaticEvents: false)
        // Mixpanel.mainInstance().track(event: "App Start")
        // Mixpanel.mainInstance().identify(distinctId: userId)
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()

        return true
    }
}
