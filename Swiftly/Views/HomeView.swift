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
                NavigationLink(destination: CalendarView()) {
                    SharedComponents.card {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Calendar")
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
