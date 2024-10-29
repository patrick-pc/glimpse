//
//  HomeView.swift
//  Swiftly
//
//  Created by Patrick on 10/25/24.
//

import RevenueCat
import StoreKit
import SuperwallKit
import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                Text("Welcome to Swiftly")
                    .font(.title)
                    .fontWeight(.bold)

                Spacer()
            }
        }
    }
}

#Preview {
    HomeView()
}
