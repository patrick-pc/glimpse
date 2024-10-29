//
//  MainViewModel.swift
//  Swiftly
//
//  Created by Patrick on 10/25/24.
//

import Foundation
import RevenueCat
import SwiftUI

class MainViewModel: NSObject, ObservableObject {
    @Published var currentPage: Page = .onboarding
    @Published var isPro = false
    @Published var showHalfOff = false
    @Published var errorMessage: String?

    func refreshCustomerInfo() {
        Purchases.shared.getCustomerInfo { [weak self] customerInfo, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.checkSubscriptionStatus(customerInfo: customerInfo)
                }
            }
        }
    }

    func checkSubscriptionStatus(customerInfo: CustomerInfo?) {
        isPro = customerInfo?.entitlements["Pro"]?.isActive == true
    }
}

extension MainViewModel: PurchasesDelegate {
    func purchases(_: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        DispatchQueue.main.async {
            self.checkSubscriptionStatus(customerInfo: customerInfo)
        }
    }
}
