//
//  HomeView.swift
//  Swiftly
//
//  Created by Patrick on 10/25/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var userDefaults: [String: Any] = [:]

    @State private var showSettings = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if let currentUser = authVM.currentUser {
                    UserInfoSection(title: "Current User", user: currentUser)
                } else {
                    Text("No current user data available")
                }

                HStack {
                    Button("Settings") {
                        showSettings = true
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)

                    Spacer()

                    Button("Sign Out") {
                        authVM.signOut()
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

struct UserInfoSection: View {
    let title: String
    let user: User

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)

            InfoRow(label: "ID", value: user.id)
            InfoRow(label: "Name", value: user.name)
            InfoRow(label: "Email", value: user.email)
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
    HomeView()
        .environmentObject(AuthViewModel())
}
