//
//  AuthViewModel.swift
//  Swiftly
//
//  Created by Patrick on 10/25/24.
//

import AuthenticationServices
import CryptoKit
import FirebaseAuth
import FirebaseFirestore
import Foundation

enum AuthState {
    case unauthenticated
    case authenticating
    case authenticated
}

@MainActor
class AuthViewModel: NSObject, ObservableObject {
    @Published var authState: AuthState = .unauthenticated
    @Published var currentUser: User?
    @Published var error: AuthError?

    private let db = Firestore.firestore()
    private var currentNonce: String?
    private var authStateListener: AuthStateDidChangeListenerHandle?

    override init() {
        super.init()
        listenToAuthState()
    }

    deinit {
        if let handle = authStateListener {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    // MARK: - Authentication State Listener

    private func listenToAuthState() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task {
                if let user = user {
                    self?.authState = .authenticated
                    await self?.fetchUser(uid: user.uid)
                } else {
                    self?.authState = .unauthenticated
                    self?.currentUser = nil
                }
            }
        }
    }

    // MARK: - Fetch User Data

    private func fetchUser(uid: String) async {
        do {
            let document = try await db.collection("users").document(uid).getDocument()
            if document.exists {
                let user = try document.data(as: User.self)
                await MainActor.run {
                    self.currentUser = user
                }
                print("Successfully fetched user:", user.id, user.name)
            } else {
                print("No user document found for uid:", uid)
                // Optionally, create a new user document here
            }
        } catch {
            print("Error fetching user:", error.localizedDescription)
            self.error = .fetchUserFailed
        }
    }

    // MARK: - Sign In with Apple

    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }

    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case let .failure(failure):
            print("Sign-in with Apple failed:", failure.localizedDescription)
            self.error = .signInWithAppleFailed(failure.localizedDescription)
        case let .success(authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: a login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identify token.")
                    self.error = .unableToFetchIdentityToken
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data:", appleIDToken.debugDescription)
                    self.error = .unableToSerializeIdentityToken
                    return
                }

                let credential = OAuthProvider.credential(
                    withProviderID: "apple.com",
                    idToken: idTokenString,
                    rawNonce: nonce
                )

                Task {
                    await signInWithFirebase(credential: credential, appleIDCredential: appleIDCredential)
                }
            }
        }
    }

    private func signInWithFirebase(credential: AuthCredential, appleIDCredential: ASAuthorizationAppleIDCredential) async {
        do {
            let authResult = try await Auth.auth().signIn(with: credential)
            let firebaseUser = authResult.user

            // Fetch user data from Firestore
            await fetchUser(uid: firebaseUser.uid)

            // Create user document in Firestore if it doesn't exist
            if currentUser == nil {
                let name = appleIDCredential.fullName != nil ? appleIDCredential.displayName() : ""
                let email = firebaseUser.email ?? appleIDCredential.email ?? ""
                let newUser = User(
                    id: firebaseUser.uid,
                    name: name,
                    email: email,
                    fcmToken: "" // TODO: Replace with actual FCM token if available
                )
                do {
                    try await db.collection("users").document(firebaseUser.uid).setData(from: newUser)
                    await MainActor.run {
                        self.currentUser = newUser
                    }
                    print("Created new user in Firestore:", newUser.id)
                } catch {
                    print("Error adding user to Firestore:", error.localizedDescription)
                    self.error = .custom(message: "Error creating user profile.")
                }
            } else {
                // User exists, update authState and currentUser
                authState = .authenticated
            }

        } catch {
            print("Error during Firebase sign-in:", error.localizedDescription)
            self.error = .authenticationFailed
        }
    }

    // MARK: - Sign Out

    func signOut() {
        do {
            try Auth.auth().signOut()
            authState = .unauthenticated
        } catch {
            print("Error signing out:", error.localizedDescription)
            self.error = .signOutFailed
        }
    }
}


// MARK: - Auth Helper Extensions and Functions
extension ASAuthorizationAppleIDCredential {
    func displayName() -> String {
        return [fullName?.givenName, fullName?.familyName]
            .compactMap { $0 }
            .joined(separator: " ")
    }
}

private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    var randomBytes = [UInt8](repeating: 0, count: length)
    let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
    if errorCode != errSecSuccess {
        fatalError(
            "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
    }

    let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

    let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
    }

    return String(nonce)
}

private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
    }.joined()

    return hashString
}

// MARK: - Custom Error Handling

enum AuthError: LocalizedError, Identifiable {
    case signInWithAppleFailed(String)
    case authenticationFailed
    case signOutFailed
    case fetchUserFailed
    case unableToFetchIdentityToken
    case unableToSerializeIdentityToken
    case custom(message: String)

    var id: String {
        errorDescription ?? UUID().uuidString
    }

    var errorDescription: String? {
        switch self {
        case .signInWithAppleFailed(let message):
            return "Sign-in with Apple failed: \(message)"
        case .authenticationFailed:
            return "Authentication failed. Please try again."
        case .signOutFailed:
            return "Sign-out failed. Please try again."
        case .fetchUserFailed:
            return "Error fetching user data."
        case .unableToFetchIdentityToken:
            return "Unable to fetch identity token."
        case .unableToSerializeIdentityToken:
            return "Unable to serialize identity token."
        case .custom(let message):
            return message
        }
    }
}
