import SwiftUI

struct SplashView: View {
    @Environment(\.theme) var theme

    @State private var isActive = false
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0.75

    var body: some View {
        ZStack {
            theme.backgroundColor.ignoresSafeArea(.all)

            VStack(spacing: 16) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)

                Text("glimpse")
                    .foregroundStyle(theme.primaryColor)
            }
            .font(.title)
            .fontWeight(.semibold)
            .opacity(opacity)
            .scaleEffect(scale)
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.5)) {
                opacity = 1
                scale = 1
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}
