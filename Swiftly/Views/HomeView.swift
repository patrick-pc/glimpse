import Mixpanel
import RevenueCat
import SuperwallKit
import SwiftUI

struct HomeView: View {
    @Environment(\.theme) var theme
    @EnvironmentObject var mainVM: MainViewModel

    @State private var selectedTab = 0
    @State private var showSettingsScreen = false
    @State private var showTryOnScreen = false
    @State private var hapticFeedback = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedTab) {
                MainView()
                    .tag(0)
                GalleryView()
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        Superwall.shared.register(event: "feature_locked")
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 8))
                            Text("Get PRO")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundStyle(theme.primaryColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        // .background(
                        //     LinearGradient(
                        //         // gradient: Gradient(colors: [Color(hex: "#A3C5FE"), Color(hex: "#BCA9FC")]),
                        //         gradient: Gradient(colors: [Color(hex: "#8FA4FC"), Color(hex: "#F8C3CB")]),
                        //         startPoint: .leading,
                        //         endPoint: .trailing
                        //     )
                        // )
                        .background(theme.fillColor)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(theme.mutedColor, lineWidth: 1)
                        )
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView(), isActive: $showSettingsScreen) {
                        Image(systemName: "gearshape.fill")
                            .font(.subheadline)
                            .foregroundStyle(theme.primaryColor)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                }
            }

            // MARK: - Bottom Navigation Bar

            HStack {
                Spacer()
                Button(action: {
                    selectedTab = 0
                }) {
                    Image(systemName: "tshirt")
                        .font(.subheadline)
                        .foregroundStyle(selectedTab == 0 ? theme.primaryColor : theme.accentColor)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }

                Spacer()

                Button(action: {
                    showTryOnScreen.toggle()
                }) {
                    Image(systemName: "sparkle")
                        .font(.title3)
                        .foregroundStyle(Color.white)
                        .frame(width: 56, height: 56)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.indigo.opacity(0.2),
                                    Color.purple.opacity(0.2),
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(theme.mutedColor.opacity(0.5), lineWidth: 1)
                        )
                        .contentShape(Circle())
                }
                .fullScreenCover(isPresented: $showTryOnScreen) {
                    TryOnView()
                }

                Spacer()

                Button(action: {
                    selectedTab = 1
                }) {
                    Image(systemName: "person")
                        // .font(.subheadline)
                        .foregroundStyle(selectedTab == 1 ? theme.primaryColor : theme.accentColor)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                Spacer()
            }
            .padding(.vertical, 8)
        }
    }
}
