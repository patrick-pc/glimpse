import SwiftUI

struct ContentView: View {
    @EnvironmentObject var mainVM: MainViewModel
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.theme) var theme

    var body: some View {
        NavigationStack {
            GeometryReader { _ in
                ZStack {
                    theme.backgroundColor.ignoresSafeArea(.all)

                    if authVM.authState == .unauthenticated {
                        AuthView()
                    } else {
                        HomeView()
                    }
                }
            }
        }
        .tint(theme.secondaryColor)
        .foregroundStyle(theme.primaryColor)
        .onAppear {
            setupInitialState()
        }
        .alert(item: $authVM.error) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("OK")) {
                    authVM.error = nil
                }
            )
        }
    }

    private func setupInitialState() {
        if authVM.authState == .authenticated {
            mainVM.currentPage = .home
        } else {
            mainVM.currentPage = .onboarding
        }

        mainVM.checkSubscriptionStatus()
    }
}
