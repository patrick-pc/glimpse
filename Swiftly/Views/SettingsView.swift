import MessageUI
import Mixpanel
import RevenueCat
import StoreKit
import SuperwallKit
import SwiftUI

struct SettingsView: View {
    @Environment(\.theme) var theme
    @Environment(\.dismiss) var dismiss
    @Environment(\.requestReview) var requestReview

    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var mainVM: MainViewModel

    @State private var showShareSheet = false
    @State private var showDeleteAccountConfirmation = false
    @State private var isDeleting = false
    @State private var showReferralCodeSheet = false
    @State private var showReferralSuccessToast = false
    @State private var showRestorePurchasesDialog = false
    @State private var restorePurchasesMessage = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // MARK: - Entitlements

                if mainVM.isPro {
                    ProPlanCard()
                } else {
                    FreePlanCard()
                }

                // MARK: - General

                SharedComponents.card {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("General")
                            .font(.subheadline)
                            .foregroundStyle(theme.secondaryColor)

                        VStack(spacing: 0) {
                            Button(action: {
                                showReferralCodeSheet = true
                            }) {
                                HStack {
                                    Image(systemName: "person.fill.badge.plus")
                                        .padding(.trailing, 8)
                                        .foregroundStyle(theme.secondaryColor)
                                    Text("Referral Code")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(theme.secondaryColor)
                                }
                                .padding(.vertical, 16)
                            }

                            Divider()
                                .padding(.leading, 36)

                            Button(action: {
                                showShareSheet.toggle()
                                Analytics.shared.log(event: "SettingsView: Tapped Share")
                            }) {
                                HStack {
                                    Image(systemName: "square.and.arrow.up.fill")
                                        .padding(.trailing, 8)
                                        .foregroundStyle(theme.secondaryColor)
                                    Text("Share Glimpse")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(theme.secondaryColor)
                                }
                                .padding(.top, 16)
                            }
                        }
                    }
                    .padding(8)
                }

                // MARK: - Support

                SharedComponents.card {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Support")
                            .font(.subheadline)
                            .foregroundStyle(theme.secondaryColor)

                        VStack(spacing: 0) {
                            Button(action: {
                                let email = "hey@trybiome.app"
                                let subject = "Contact Support - Biome App"
                                if let url = URL(string: "mailto:\(email)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") {
                                    UIApplication.shared.open(url)
                                }
                                Analytics.shared.log(event: "SettingsView: Tapped Contact Us")
                            }) {
                                HStack {
                                    Image(systemName: "message.fill")
                                        .padding(.trailing, 8)
                                        .foregroundStyle(theme.secondaryColor)
                                    Text("Contact Us")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(theme.secondaryColor)
                                }
                                .padding(.vertical, 16)
                            }
                            Divider()
                                .padding(.leading, 36)

                            Button(action: {
                                requestReview()
                                Analytics.shared.log(event: "SettingsView: Tapped Review")
                            }) {
                                HStack {
                                    Image(systemName: "star.fill")
                                        .padding(.trailing, 8)
                                        .foregroundStyle(theme.secondaryColor)
                                    Text("Leave a Review")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(theme.secondaryColor)
                                }
                                .padding(.vertical, 16)
                            }
                            Divider()
                                .padding(.leading, 36)

                            Button(action: {
                                if let url = URL(string: "https://patrickpc.notion.site/152bae23d97c81d498b7c8f23ad16645") {
                                    UIApplication.shared.open(url)
                                }
                                Analytics.shared.log(event: "SettingsView: Tapped Submit Feature Request")
                            }) {
                                HStack {
                                    Image(systemName: "sparkle")
                                        .padding(.trailing, 8)
                                        .foregroundStyle(theme.secondaryColor)
                                    Text("Submit Feature Request")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(theme.secondaryColor)
                                }
                                .padding(.vertical, 16)
                            }
                            Divider()
                                .padding(.leading, 36)

                            Button(action: {
                                if let url = URL(string: "https://patrickpc.notion.site/152bae23d97c81baac63fe24b9602f62") {
                                    UIApplication.shared.open(url)
                                }
                                Analytics.shared.log(event: "SettingsView: Tapped Submit Bug Report or Question")
                            }) {
                                HStack {
                                    Image(systemName: "exclamationmark.bubble.fill")
                                        .padding(.trailing, 6)
                                        .foregroundStyle(theme.secondaryColor)
                                    Text("Submit Bug Report or Question")
                                        .lineLimit(1)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(theme.secondaryColor)
                                }
                                .padding(.top, 16)
                            }
                        }
                    }
                    .padding(8)
                }

                // MARK: - Legal

                SharedComponents.card {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Legal")
                            .font(.subheadline)
                            .foregroundStyle(theme.secondaryColor)

                        VStack(spacing: 0) {
                            Link(destination: URL(string: "https://bytehouse-io.github.io/biome-privacy-policy/")!) {
                                HStack {
                                    Image(systemName: "lock.fill")
                                        .padding(.trailing, 8)
                                        .foregroundStyle(theme.secondaryColor)
                                    Text("Privacy Policy")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(theme.secondaryColor)
                                }
                                .padding(.vertical, 16)
                            }
                            Divider()
                                .padding(.leading, 36)

                            Link(destination: URL(string: "https://bytehouse-io.github.io/biome-terms/")!) {
                                HStack {
                                    Image(systemName: "doc.text.fill")
                                        .padding(.trailing, 8)
                                        .foregroundStyle(theme.secondaryColor)
                                    Text("Terms of Service")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(theme.secondaryColor)
                                }
                                .padding(.top, 16)
                            }
                        }
                    }
                    .padding(8)
                }

                // MARK: - Account

                SharedComponents.card {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Account")
                            .font(.subheadline)
                            .foregroundStyle(theme.secondaryColor)

                        VStack(spacing: 0) {
                            #if targetEnvironment(simulator)
                                Button(action: {
                                    Task {
                                        await authVM.showManageSubscriptions()
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "creditcard.viewfinder")
                                            .padding(.trailing, 6)
                                            .foregroundStyle(theme.secondaryColor)
                                        Text("Manage Subscription")
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(theme.secondaryColor)
                                    }
                                    .padding(.vertical, 16)
                                }
                                Divider()
                                    .padding(.leading, 36)
                            #endif

                            Button(action: {
                                Task {
                                    Analytics.shared.log(event: "SettingsView: Tapped Restore Purchases")
                                    let result = await RCPurchaseController().restorePurchases()
                                    switch result {
                                    case .restored:
                                        mainVM.checkSubscriptionStatus()
                                        restorePurchasesMessage = "Your purchases have been restored."
                                        showRestorePurchasesDialog = true
                                    case let .failed(error):
                                        if let error = error {
                                            restorePurchasesMessage = error.localizedDescription
                                        } else {
                                            restorePurchasesMessage = "Failed to restore purchases"
                                        }
                                        showRestorePurchasesDialog = true
                                    }
                                }
                            }) {
                                HStack {
                                    Image(systemName: "arrow.clockwise")
                                        .padding(.trailing, 8)
                                        .foregroundStyle(theme.secondaryColor)
                                    Text("Restore Purchases")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(theme.secondaryColor)
                                }
                                .padding(.vertical, 16)
                            }

                            Divider()
                                .padding(.leading, 36)

                            Button(action: {
                                authVM.signOut()
                                dismiss()
                            }) {
                                HStack {
                                    Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                                        .padding(.trailing, 4)
                                        .foregroundStyle(theme.secondaryColor)
                                    Text("Sign Out")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(theme.secondaryColor)
                                }
                                .padding(.vertical, 16)
                            }

                            Divider()
                                .padding(.leading, 36)

                            Button(action: {
                                Analytics.shared.log(event: "SettingsView: Initiated Account Deletion")
                                showDeleteAccountConfirmation = true
                            }) {
                                HStack {
                                    Image(systemName: "trash.fill")
                                        .padding(.trailing, 8)
                                    Text("Delete Account")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                                .foregroundStyle(Color.red)
                                .padding(.top, 16)
                            }
                            .disabled(isDeleting)
                        }
                    }
                    .padding(8)
                }

                VStack(alignment: .center, spacing: 8) {
                    Text("v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown") (\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"))")
                        .font(.caption)
                        .foregroundStyle(theme.secondaryColor)
                        .multilineTextAlignment(.center)

                    Text(Purchases.shared.appUserID)
                        .font(.caption)
                        .foregroundStyle(theme.secondaryColor)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 16)
            }
            .padding(.top)
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .sheet(isPresented: $showShareSheet) {
            ShareView(items: ["Check out Biome - The Ultimate Gut Health App", "https://apps.apple.com/us/app/biome-gut-health-improvement/id6738016955"])
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showReferralCodeSheet) {
            NavigationStack {
                ReferralCodeView(onSuccess: {
                    Analytics.shared.log(event: "SettingsView: Applied Referral Code")
                    // Show toast after a brief delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showReferralSuccessToast = true
                        // Hide toast after 2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showReferralSuccessToast = false
                        }
                    }
                })
                .navigationBarTitleDisplayMode(.inline)
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
        .overlay {
            if showReferralSuccessToast {
                VStack {
                    Text("🎉 Referral code applied successfully!")
                        .font(.subheadline)
                        .foregroundStyle(theme.backgroundColor)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(theme.primaryColor)
                        .cornerRadius(32)
                        .padding(.top, 24)
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut, value: showReferralSuccessToast)
        .confirmationDialog(
            "Delete Account",
            isPresented: $showDeleteAccountConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete Account", role: .destructive) {
                isDeleting = true
                Task {
                    do {
                        Analytics.shared.log(event: "SettingsView: Deleted Account")
                        try await authVM.deleteAccount()
                        // Clear all UserDefaults
                        if let bundleIdentifier = Bundle.main.bundleIdentifier {
                            UserDefaults.standard.removePersistentDomain(forName: bundleIdentifier)
                        }
                        // Account deletion will trigger sign out automatically
                        dismiss()
                    } catch {
                        print("Error deleting account: \(error.localizedDescription)")
                    }
                    isDeleting = false
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone. All your data will be permanently deleted.")
        }
        .alert("Restore Purchases", isPresented: $showRestorePurchasesDialog) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(restorePurchasesMessage)
        }
    }
}

struct ProPlanCard: View {
    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 120)
                .cornerRadius(16)
                .frame(maxWidth: .infinity)

            HStack {
                Image("robot")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .offset(y: 10)

                Spacer()

                Image("star")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(15))
                    .padding(.trailing, 60)
                    .offset(y: -20)
            }

            VStack(alignment: .leading) {
                Spacer()

                Text("Glimpse PRO")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.white)

                Spacer()
            }

            GeometryReader { geometry in
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .position(x: geometry.size.width - 20, y: geometry.size.height - 20)
            }
        }
        .frame(height: 120)
    }
}

struct FreePlanCard: View {
    @Environment(\.theme) var theme

    var body: some View {
        SharedComponents.card {
            VStack(alignment: .leading, spacing: 4) {
                Text("You're on a Free Plan")
                    .font(.title3)
                    .fontWeight(.semibold)

                Text("Upgrade to PRO for unlimited try-ons")
                    .font(.subheadline)
                    .foregroundStyle(theme.secondaryColor)

                SharedComponents.secondaryButton(title: "Try for $0.00") {
                    Superwall.shared.register(event: "feature_locked")
                }
                .padding(.top, 12)
            }
            .padding(8)
        }
    }
}
