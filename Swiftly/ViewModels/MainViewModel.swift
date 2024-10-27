//
//  MainViewModel.swift
//  Swiftly
//
//  Created by Patrick on 10/25/24.
//

import Foundation
import SwiftUI

class MainViewModel: NSObject, ObservableObject {
    @Published var currentPage: Page = .onboarding
    @Published var isPro = false
    @Published var showHalfOff = false
}
