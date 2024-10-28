//
//  MainViewModel.swift
//  Swiftly
//
//  Created by Patrick on 10/25/24.
//

import Foundation
import SwiftUI
import RevenueCat
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
                    self?.updateEntitlements(customerInfo: customerInfo)
                }
            }
        }
    }

    func updateEntitlements(customerInfo: CustomerInfo?) {
        self.isPro = customerInfo?.entitlements["Pro"]?.isActive == true
    }
}
extension MainViewModel: PurchasesDelegate {
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        DispatchQueue.main.async {
            self.updateEntitlements(customerInfo: customerInfo)
        }
    }
}
