//
//  OpenAIService.swift
//  Swiftly
//
//  Created by Patrick on 10/29/24.
//

import FirebaseFunctions
import Foundation

struct TryOnStatus {
    let id: String
    let status: String
    let output: [String]?
    let error: String?

    init(from response: [String: Any]) throws {
        guard let id = response["id"] as? String,
              let status = response["status"] as? String
        else {
            throw NSError(
                domain: "OpenAIService",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Invalid status response format"]
            )
        }

        self.id = id
        self.status = status
        output = response["output"] as? [String]
        error = response["error"] as? String
    }

    var isCompleted: Bool {
        return status == "completed"
    }

    var isFailed: Bool {
        return status == "failed"
    }
}

class OpenAIService {
    private let functions: Functions

    init() {
        #if DEBUG
            // Use local emulator in debug builds
            print("@@@ using local emulator")
            functions = Functions.functions()
            functions.useEmulator(withHost: "127.0.0.1", port: 5001)
        #else
            // Use production environment in release builds
            functions = Functions.functions()
        #endif
    }

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

    func analyzeImage(base64Image: String) async throws -> [String: Any] {
        let data = ["image": base64Image]

        let result = try await functions.httpsCallable("openai-api/vision").call(data)

        guard let response = result.data as? [String: Any],
              let choices = response["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String
        else {
            throw NSError(
                domain: "OpenAIService",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Invalid response format"]
            )
        }

        // Parse the content string which contains the JSON
        guard let contentData = content.data(using: .utf8),
              let jsonResponse = try? JSONSerialization.jsonObject(with: contentData) as? [String: Any]
        else {
            throw NSError(
                domain: "OpenAIService",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Invalid JSON content format"]
            )
        }

        return jsonResponse
    }

    func tryOn(modelImage: String, garmentImage: String, category: String) async throws -> [String: Any] {
        let data: [String: Any] = [
            "model_image": modelImage,
            "garment_image": garmentImage,
            "category": category,
        ]

        let result = try await functions.httpsCallable("tryon-api/fashn").call(data)

        guard let response = result.data as? [String: Any] else {
            throw NSError(
                domain: "OpenAIService",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Invalid response format"]
            )
        }

        return response
    }

    func checkTryOnStatus(id: String) async throws -> TryOnStatus {
        let data = ["id": id]

        let result = try await functions.httpsCallable("tryon-api/fashn/status").call(data)

        guard let response = result.data as? [String: Any] else {
            throw NSError(
                domain: "OpenAIService",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Invalid response format"]
            )
        }

        return try TryOnStatus(from: response)
    }
}
