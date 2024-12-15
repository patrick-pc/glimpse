//
//  MainViewModel.swift
//  Swiftly
//
//  Created by Patrick on 10/25/24.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import Foundation
import Mixpanel
import RevenueCat
import SwiftUI

enum Page: String {
    case splash = "Splash"
    case auth = "Auth"
    case onboarding = "Onboarding"
    case home = "Home"
}

class MainViewModel: NSObject, ObservableObject {
    @Published var currentPage: Page = .onboarding
    @Published var isPro = false
    @Published var showHalfOff = false
    @Published var errorMessage: String?

    func checkSubscriptionStatus() {
        print("@@@ checkSubscriptionStatus")

        Purchases.shared.getCustomerInfo { purchaserInfo, error in
            if let error = error {
                // Handle any errors that occurred
                print("Error checking subscription status: \(error.localizedDescription)")
                Analytics.shared.logActual(event: "User: Error Checking Subscription Status", parameters: ["error": error.localizedDescription])
                return
            }

            // Check if the user has an active pro subscription
            if let entitlements = purchaserInfo?.entitlements {
                if let subscription = entitlements["Pro"] {
                    print("@@@ subscription", subscription.productIdentifier)

                    if subscription.isActive {
                        self.isPro = subscription.isActive == true

                        if subscription.willRenew {
                            Analytics.shared.logActual(event: "User: Will Renewal", parameters: ["product": purchaserInfo?.entitlements["Pro"]?.productIdentifier ?? ""])
                        } else {
                            if UserDefaults.standard.bool(forKey: "renewalOff") {
                                Analytics.shared.logActual(event: "User: Turned Of Renewal", parameters: ["product": purchaserInfo?.entitlements["Pro"]?.productIdentifier ?? ""])
                                UserDefaults.standard.setValue(true, forKey: "renewalOff")
                            }
                        }
                    } else {
                        print("@@@ subscription is not active cancelled or expired")
                        if UserDefaults.standard.bool(forKey: "expired") {
                            Analytics.shared.logActual(event: "User: Subscription Expired", parameters: ["product": purchaserInfo?.entitlements["Pro"]?.productIdentifier ?? ""])
                            UserDefaults.standard.setValue(true, forKey: "expired")
                        }
                    }
                } else {
                    self.isPro = false
                    print("@@@ no active subscription")
                }
            }

            print("@@@ isPro \(self.isPro)")
        }
    }
}

extension MainViewModel: PurchasesDelegate {
    func purchases(_: Purchases, receivedUpdated _: CustomerInfo) {
        checkSubscriptionStatus()
    }
}
