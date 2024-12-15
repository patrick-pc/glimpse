import AuthenticationServices
import SwiftUI

struct AuthView: View {
    @Environment(\.theme) var theme
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 84, height: 84)

            VStack(alignment: .center, spacing: 8) {
                Text("Welcome to glimpse")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("Discover your new fit")
                    .foregroundStyle(theme.secondaryColor)
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
