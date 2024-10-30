//
//  HomeView.swift
//  Swiftly
//
//  Created by Patrick on 10/25/24.
//

import RevenueCat
import StoreKit
import SuperwallKit
import SwiftUI

struct HomeView: View {
    @State private var messages: [[String: String]] = []
    @State private var inputText = ""
    @State private var isLoading = false
    let openAIService = OpenAIService()

    var body: some View {
        VStack {
            ScrollView {
                ForEach(messages, id: \.self) { message in
                    MessageView(message: message)
                }
            }

            HStack {
                TextField("Type a message", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(isLoading)

                Button(action: sendMessage) {
                    Text(isLoading ? "Sending..." : "Send")
                }
                .disabled(isLoading || inputText.isEmpty)
            }
            .padding()
        }
    }

    func sendMessage() {
        let userMessage = ["role": "user", "content": inputText]
        messages.append(userMessage)
        inputText = ""
        isLoading = true

        Task {
            do {
                let message = try await openAIService.chatCompletion(messages: messages)
                await MainActor.run {
                    if let content = message["content"] as? String {
                        messages.append(["role": "assistant", "content": content])
                    }
                    isLoading = false
                }
            } catch {
                print("Error: \(error.localizedDescription)")
                await MainActor.run {
                    isLoading = false
                }
            }
        }
    }
}

struct MessageView: View {
    let message: [String: String]

    var body: some View {
        HStack {
            if message["role"] == "user" {
                Spacer()
                Text(message["content"] ?? "")
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(10)
            } else {
                Text(message["content"] ?? "")
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    HomeView()
}
