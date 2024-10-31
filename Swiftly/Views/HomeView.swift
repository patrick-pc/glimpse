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
                NavigationLink(destination: ChatView()) {
                    SharedComponents.card {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Chat")
                                .font(.headline)
                        }
                    }
                }
                NavigationLink(destination: VisionView()) {
                    SharedComponents.card {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Vision")
                                .font(.headline)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
