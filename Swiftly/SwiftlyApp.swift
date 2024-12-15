//
//  SwiftlyApp.swift
//  Swiftly
//
//  Created by Patrick on 10/25/24.
//

import FirebaseCore
import RevenueCat
import SuperwallKit
import SwiftUI

@main
struct SwiftlyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var mainViewModel = MainViewModel()
    @StateObject private var themeManager = ThemeManager()

    @State private var showSplashScreen = true

    init() {
        setup()
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environmentObject(authViewModel)
                    .environmentObject(mainViewModel)

                if showSplashScreen {
                    SplashView()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .environmentObject(themeManager)
            .withTheme(themeManager)
            .preferredColorScheme(.dark)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showSplashScreen = false
                    }
                }
            }
        }
    }

    func setup() {
        let secondLaunch = UserDefaults.standard.bool(forKey: "firstLaunch")

        if !secondLaunch {
            let userId = UUID().uuidString
            UserDefaults.standard.setValue(userId, forKey: "userId")
            UserDefaults.standard.setValue(true, forKey: "firstLaunch")
        }

        let userId = UserDefaults.standard.string(forKey: "userId") ?? ""

        // MARK: - Create Purchase Controller

        let purchaseController = RCPurchaseController()

        // MARK: - Configure Superwall

        /// Always configure Superwall first. Pass in the `purchaseController` you just created.
        Superwall.configure(
            apiKey: "pk_d2def9c411cab0518870cd3e6d85ef89b30ecbd97b3381a0",
            purchaseController: purchaseController
        )
        Superwall.shared.identify(userId: userId) // NOTE: Removed this because we're using RevenueCat's anonymous ID

        // MARK: - Configure RevenueCat

        // /// Always configure RevenueCat after Superwall
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_QohpDVLiJahGHiefKIJjWTQTafm", appUserID: userId)

        // MARK: - Sync Subscription Status

        /// Keep Superwall's subscription status up-to-date with RevenueCat's.
        purchaseController.syncSubscriptionStatus()

        // MARK: - AppsFlyer

        // AppsFlyerLib.shared().appsFlyerDevKey = "C43LbYriLHEuMFtNv7zhJT"
        // AppsFlyerLib.shared().appleAppID = Constants.appId
        // AppsFlyerLib.shared().customerUserID = userId
        // AppsFlyerLib.shared().logEvent("App Started", withValues: [:])
        // AppsFlyerLib.shared().isDebug = false
        // AppsFlyerLib.shared().start()

        // Purchases.shared.attribution.setAppsflyerID(AppsFlyerLib.shared().getAppsFlyerUID())

        // MARK: - Mixpanel

        // Mixpanel.initialize(token: "ff167a2e39231020ec359a807f32484b", trackAutomaticEvents: false)
        // Mixpanel.mainInstance().track(event: "App Started")
        // Mixpanel.mainInstance().identify(distinctId: userId)

        // Purchases.shared.attribution.setMixpanelDistinctID(userId)
    }

    private func colorSchemeForThemeMode(_ mode: ThemeMode) -> ColorScheme? {
        switch mode {
        case .system, .custom:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let userId = UserDefaults.standard.string(forKey: "userId") ?? ""

        // MARK: - Configure Firebase

        FirebaseApp.configure()

        return true
    }
}
