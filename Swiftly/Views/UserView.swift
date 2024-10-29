//
//  UserView.swift
//  Swiftly
//
//  Created by Patrick on 10/29/24.
//

import RevenueCat
import StoreKit
import SuperwallKit
import SwiftUI

struct UserView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var mainVM: MainViewModel

    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if let currentUser = authVM.currentUser {
                        InfoRow(label: "ID", value: currentUser.id)
                        InfoRow(label: "Name", value: currentUser.name)
                        InfoRow(label: "Email", value: currentUser.email)
                        InfoRow(label: "RC Entitlement", value: mainVM.isPro ? "Pro" : "Free")
                    }

                    SharedComponents.card {
                        Text("Card")
                    }

                    SharedComponents.roundButton(title: "Sign Out") {
                        authVM.signOut()
                    }
                }
                .padding()
            }
        }
        .toolbar {
            if mainVM.isPro {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        Superwall.shared.register(event: "campaign_trigger")
                    }) {
                        HStack {
                            Image(systemName: "sparkles")
                            Text("Paywall")
                        }
                        // .font(.system(size: 12, weight: .medium))
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.primary.opacity(0.1))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.primary.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "gearshape.fill")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .fontWeight(.medium)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    UserView()
        .environmentObject(AuthViewModel())
}
