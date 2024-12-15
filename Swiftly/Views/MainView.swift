import Mixpanel
import SuperwallKit
import SwiftUI

struct MainView: View {
    @Environment(\.theme) var theme

    @State private var showTryOnScreen = false

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                GlimpseCard()

                HStack(alignment: .top, spacing: 16) {
                    VStack(spacing: 16) {
                        // Left column
                        ForEach(0 ..< 3) { _ in
                            PlaceholderImage()
                        }
                    }

                    VStack(spacing: 16) {
                        // Right column
                        ForEach(0 ..< 3) { _ in
                            PlaceholderImage()
                        }
                    }
                    .padding(.top, 32)
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            // Analytics.shared.log(event: "MainView: Viewed")
        }
    }

    private func PlaceholderImage() -> some View {
        Rectangle()
            .fill(theme.fillColor)
            .frame(width: (UIScreen.main.bounds.width - 48) / 2, height: (UIScreen.main.bounds.width - 48) / 2 * 16 / 9)
            .cornerRadius(16)
            .overlay(
                Image(systemName: "photo")
                    .foregroundColor(theme.accentColor)
            )
    }

    private func GlimpseCard() -> some View {
        ZStack {
            Image("bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .overlay(
                    VStack {
                        Text("Welcome to glimpse")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(Color.white)
                            .shadow(radius: 2)

                        Text("Discover your new fit")
                            .font(.subheadline)
                            .foregroundStyle(Color.white)
                            .shadow(radius: 2)
                    }
                )

            Image(systemName: "sparkle")
                .font(.caption)
                .foregroundStyle(Color.white)
                .offset(x: 115, y: -17)

            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Image("shirt")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                        .padding(.leading, 10)
                        .rotationEffect(.degrees(-10))

                    Spacer()

                    Image("jacket")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(-15))
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                }

                Spacer()

                HStack(spacing: 0) {
                    Image("statue")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)

                    Spacer()

                    Button(action: {
                        showTryOnScreen.toggle()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "sparkles")
                            Text("Get Started")
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 8)
                        .foregroundStyle(Color.black)
                        .background(Color.white)
                        .clipShape(Capsule())
                    }
                    .padding(.bottom, 16)
                    .opacity(0.8)
                    .fullScreenCover(isPresented: $showTryOnScreen) {
                        TryOnView()
                    }

                    Spacer()

                    Image("women")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                }
            }
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
        .padding(.top, 8)
        .padding(.bottom, 16)
    }
}
