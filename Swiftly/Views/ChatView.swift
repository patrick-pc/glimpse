import RevenueCat
import StoreKit
import SuperwallKit
import SwiftUI

struct ChatView: View {
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

            Spacer()
            HStack {
                TextField("Ask anything...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(isLoading)

                Button(action: sendMessage) {
                    Image(systemName: "paperplane")
                }
                .buttonStyle(.borderedProminent)
                .disabled(isLoading || inputText.isEmpty)
            }
            .padding()
        }
        .padding(.bottom, 32)
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
            } else {
                Text(message["content"] ?? "")
                    .padding()
                    .foregroundColor(Color.primary.opacity(0.8))
                    .background(Color.primary.opacity(0.1))
                    .cornerRadius(10)
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ChatView()
}
