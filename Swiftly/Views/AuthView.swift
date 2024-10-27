//
//  AuthView.swift
//  Swiftly
//
//  Created by Patrick on 10/25/24.
//

import AuthenticationServices
import SwiftUI

struct AuthView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "swift", variableValue: 0)
                .font(.system(size: 64, weight: .bold))
                .imageScale(.large)
                .symbolRenderingMode(.hierarchical)
                .frame(width: 84, height: 84)

            VStack(alignment: .center, spacing: 8) {
                Text("Welcome to Swiftly")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .fixedSize(horizontal: false, vertical: true)
                    .clipped()

                Text("Fast and flexible SwiftUI boilerplate")
                    .font(.subheadline)
                    .frame(width: 300, alignment: .top)
                    .foregroundStyle(.primary.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .clipped()
            }

            Spacer()

            SignInWithAppleButton(
                .continue,
                onRequest: { request in
                    authVM.handleSignInWithAppleRequest(request)
                },
                onCompletion: { result in
                    authVM.handleSignInWithAppleCompletion(result)
                }
            )
            .id(colorScheme == .dark ? "dark-btn" : "light-btn")
            .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .cornerRadius(25)
            .padding(.bottom, 32)
        }
        .padding()
    }
}

#Preview {
    AuthView()
}
