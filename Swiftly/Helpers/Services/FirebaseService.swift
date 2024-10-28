//
//  FirebaseService.swift
//  Swiftly
//
//  Created by Patrick on 10/25/24.
//

import Firebase
import FirebaseFirestore
import Foundation

class FirebaseService {
    static let shared = FirebaseService()

    private let db = Firestore.firestore()

    private init() {}

    // MARK: - Firestore Operations

    // Add Document
    func addDocument<T: Codable>(collection: String, data: T) async throws -> String {
        let documentRef = db.collection(collection).document()
        do {
            try documentRef.setData(from: data)
            return documentRef.documentID
        } catch {
            throw error
        }
    }

    // Update Document
    func updateDocument<T: Codable>(collection: String, documentId: String, data: T) async throws {
        let documentRef = db.collection(collection).document(documentId)
        do {
            try documentRef.setData(from: data, merge: true)
        } catch {
            throw error
        }
    }

    // Delete Document
    func deleteDocument(collection: String, documentId: String) async throws {
        let documentRef = db.collection(collection).document(documentId)
        do {
            try await documentRef.delete()
        } catch {
            throw error
        }
    }

    // Get Document by ID
    func getDocument<T: Codable>(collection: String, documentId: String) async throws -> T {
        let documentRef = db.collection(collection).document(documentId)
        do {
            let documentSnapshot = try await documentRef.getDocument()
            guard let data = try? documentSnapshot.data(as: T.self) else {
                throw FirestoreError.documentNotFound
            }
            return data
        } catch {
            throw error
        }
    }

    // Fetch Documents (with optional query)
    func getDocuments<T: Codable>(
        collection: String,
        whereField: String? = nil,
        isEqualTo value: Any? = nil,
        limit: Int? = nil
    ) async throws -> [T] {
        var query: Query = db.collection(collection)

        if let field = whereField, let value = value {
            query = query.whereField(field, isEqualTo: value)
        }

        if let limit = limit {
            query = query.limit(to: limit)
        }

        do {
            let querySnapshot = try await query.getDocuments()
            let documents = try querySnapshot.documents.compactMap { document in
                try? document.data(as: T.self)
            }

            if documents.isEmpty {
                throw FirestoreError.documentNotFound
            }

            return documents
        } catch {
            throw error
        }
    }
}

enum FirestoreError: LocalizedError {
    case documentNotFound
    case dataDecodingError
    case unknownError

    var errorDescription: String? {
        switch self {
        case .documentNotFound:
            return "Document not found."
        case .dataDecodingError:
            return "Failed to decode data."
        case .unknownError:
            return "An unknown Firestore error occurred."
        }
    }
}
