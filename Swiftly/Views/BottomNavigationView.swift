//
//  BottomNavigationView.swift
//  Swiftly
//
//  Created by Patrick on 10/26/24.
//

import SwiftUI

struct BottomNavigationView: View {
    @State private var selectedTab = 1

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedTab) {
                NavigationStack {
                    ItemView()
                }
                .tag(0)

                NavigationStack {
                    HomeView()
                }
                .tag(1)

                NavigationStack {
                    UserView()
                }
                .tag(2)
            }
            // .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Enable swipe gestures

            HStack(spacing: 24) {
                Spacer()

                Button(action: {
                    selectedTab = 0
                }) {
                    Image(systemName: "flame.fill")
                        .padding(12)
                        .foregroundStyle(.primary)
                        .background(.primary.opacity(0.1))
                }
                .clipShape(Circle())

                Button(action: {
                    selectedTab = 1
                }) {
                    Image(systemName: "swift")
                        .font(.title2)
                        .padding(18)
                        .foregroundStyle(.background)
                        .background(.primary)
                }
                .clipShape(Circle())

                Button(action: {
                    selectedTab = 2
                }) {
                    Image(systemName: "person.fill")
                        .padding(12)
                        .foregroundStyle(.primary)
                        .background(.primary.opacity(0.1))
                }
                .clipShape(Circle())

                Spacer()
            }
            .padding(.top, 6)
            .padding(.bottom, 12)
        }
        .tint(.primary)
    }
}

#Preview {
    BottomNavigationView()
}
