//
//  FirebaseService.swift
//  Swiftly
//
//  Created by Patrick on 10/25/24.
//

import Firebase
import FirebaseFirestore
import FirebaseStorage
import Foundation
import UIKit

class FirebaseService {
    static let shared = FirebaseService()

    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()

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

    func uploadImage(_ image: UIImage, path: String, completion: @escaping (Result<String, Error>) -> Void) {
        print("Starting image upload process for path: \(path)")

        // Target size for a good balance of quality and size
        // 1920x1080 is a common resolution that maintains good quality while being reasonable for mobile
        let targetSize = CGSize(width: 1920, height: 1080)

        if let processedImage = image.prepareForUpload(targetSize: targetSize) {
            // Use higher compression quality (0.8) for better image quality
            guard let imageData = processedImage.jpegData(compressionQuality: 0.8) else {
                print("Failed to convert image to JPEG data")
                completion(.failure(NSError(domain: "FirebaseService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
                return
            }

            print("Image converted to JPEG data. Size: \(imageData.count / 1024)KB")

            let imageRef = storage.child(path)

            // Set metadata for better caching and content type
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            metadata.cacheControl = "public, max-age=31536000" // Cache for 1 year

            print("Uploading image to Firebase Storage at path: \(path)")

            imageRef.putData(imageData, metadata: metadata) { metadata, error in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }

                print("Image uploaded successfully. Metadata: \(String(describing: metadata))")

                imageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                        completion(.failure(error))
                        return
                    }

                    guard let downloadURL = url else {
                        print("Download URL is nil")
                        completion(.failure(NSError(domain: "FirebaseService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])))
                        return
                    }

                    print("Download URL obtained successfully: \(downloadURL.absoluteString)")
                    completion(.success(downloadURL.absoluteString))
                }
            }
        }
    }

    func fetchImage(path: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let imageRef = storage.child(path)

        imageRef.getData(maxSize: 1024 * 1024) { data, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let imageData = data, let image = UIImage(data: imageData) else {
                completion(.failure(NSError(domain: "FirebaseService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert data to image"])))
                return
            }

            completion(.success(image))
        }
    }
}

extension UIImage {
    func prepareForUpload(targetSize: CGSize) -> UIImage? {
        // Calculate aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height

        // Use the smaller ratio to ensure image fits within target size
        let scaleFactor = min(widthRatio, heightRatio)

        // Calculate new size maintaining aspect ratio
        let scaledWidth = size.width * scaleFactor
        let scaledHeight = size.height * scaleFactor
        let newSize = CGSize(width: scaledWidth, height: scaledHeight)

        // Create graphics context with scale factor for better quality
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        defer { UIGraphicsEndImageContext() }

        // Draw image with high quality
        let context = UIGraphicsGetCurrentContext()
        context?.interpolationQuality = .high

        draw(in: CGRect(origin: .zero, size: newSize))

        return UIGraphicsGetImageFromCurrentImageContext()
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
