//
//  File.swift
//  Swiftly
//
//  Created by Patrick on 10/26/24.
//

import SwiftUI

struct NavigationView: View {
    @State private var selectedTab = 1

    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                Image(systemName: "calendar")
                    .tag(0)
                
                HomeView()
                    .tag(1)

                Image(systemName: "book.pages.fill")
                    .tag(2)
            }
            // .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Enable swipe gestures

            HStack(spacing: 24) {
                Spacer()

                Button(action: {
                    selectedTab = 0
                }) {
                    Image(systemName: "calendar")
                        .font(.system(size: 16))
                        .padding(12)
                        .foregroundStyle(.primary)
                        .background(.primary.opacity(0.1))
                        .clipShape(Circle())
                }

                Button(action: {
                    selectedTab = 1
                }) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 20))
                        .padding(20)
                        .foregroundStyle(.background)
                        .background(.primary)
                        .clipShape(Circle())
                }

                Button(action: {
                    selectedTab = 2
                }) {
                    Image(systemName: "book.pages.fill")
                        .font(.system(size: 16))
                        .padding(12)
                        .foregroundStyle(.primary)
                        .background(.primary.opacity(0.1))
                        .clipShape(Circle())
                }
                
                Spacer()
            }
            .padding(.vertical, 16)
            .background(Color(UIColor.systemBackground))
        }
        .tint(.primary)
    }
}

#Preview {
    NavigationView()
}
