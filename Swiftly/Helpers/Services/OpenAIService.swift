//
//  OpenAIService.swift
//  Swiftly
//
//  Created by Patrick on 10/29/24.
//

import FirebaseFunctions
import Foundation

class OpenAIService {
    private let functions = Functions.functions()

    func chatCompletion(messages: [[String: Any]]) async throws -> [String: String] {
        let data = ["messages": messages]
        let result = try await functions.httpsCallable("openai-api/chat").call(data)

        guard let response = result.data as? [String: Any],
              let choices = response["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String,
              let role = message["role"] as? String
        else {
            throw NSError(
                domain: "OpenAIService",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Invalid response format"]
            )
        }

        return [
            "role": role,
            "content": content,
        ]
    }
}
