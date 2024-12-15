import AppsFlyerLib
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import FirebaseFirestore
import Foundation
import Mixpanel
import RevenueCat
import StoreKit
import SuperwallKit

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
                currentUser = user
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
        case let .success(authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: a login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identify token.")
                    error = .unableToFetchIdentityToken
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data:", appleIDToken.debugDescription)
                    error = .unableToSerializeIdentityToken
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

    private func signInWithFirebase(
        credential: AuthCredential,
        appleIDCredential: ASAuthorizationAppleIDCredential
    ) async {
        do {
            let userId = Purchases.shared.appUserID ?? UserDefaults.standard.string(forKey: "userId") ?? ""
            let authResult = try await Auth.auth().signIn(with: credential)
            let firebaseUser = authResult.user
            UserDefaults.standard.set(userId, forKey: "userId")

            // Fetch user data from Firestore
            await fetchUser(uid: firebaseUser.uid)

            // Create user document in Firestore if it doesn't exist
            if currentUser == nil {
                let userToken = appleIDCredential.user
                let name = appleIDCredential.fullName != nil ? appleIDCredential.displayName() : ""
                let email = firebaseUser.email ?? appleIDCredential.email ?? ""

                let newUser = User(
                    id: userId,
                    name: name,
                    email: email,
                    appleToken: userToken
                )

                // OneSignal
                // OneSignal.login(userId)
                // OneSignal.User.addEmail(email)
                // OneSignal.User.addTag(key: "userId", value: userId)
                // OneSignal.User.addTag(key: "userId", value: firebaseUser.uid)

                // Mixpanel
                // Mixpanel.mainInstance().people.set(properties: [
                //     "$name": name,
                //     "$email": email,
                //     "appleToken": userToken,
                //     "userId": firebaseUser.uid,
                //     "oneSignalId": OneSignal.User.onesignalId,
                //     "onboardingCompleted": onboardingSelections != nil,
                //     "onboardingAnalysis": onboardingAnalysis ?? [:],
                //     "dietaryPreferences": onboardingSelections?.dietaryPreferences ?? [],
                //     "ageGroup": onboardingSelections?.ageGroup ?? "",
                //     "gender": onboardingSelections?.gender ?? "",
                //     "dateJoined": Date(),
                //     // "isPro": false, // NOTE: Removed for now since we're using RevenueCat to check this
                // ])

                // Set email and name in RevenueCat
                Purchases.shared.attribution.setEmail(email)
                Purchases.shared.attribution.setDisplayName(name)
                // Purchases.shared.attribution.setOnesignalUserID(OneSignal.User.onesignalId)

                do {
                    try await db.collection("users").document(firebaseUser.uid).setData(from: newUser)
                    currentUser = newUser
                    authState = .authenticated

                } catch {
                    print("Error adding user to Firestore:", error.localizedDescription)
                    self.error = .custom(message: "Error creating user profile.")
                }
            } else {
                // User exists, update authState
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
            // Sign out from Firebase
            try Auth.auth().signOut()

            // Reset authState
            authState = .unauthenticated
        } catch {
            print("Error signing out:", error.localizedDescription)
            self.error = .signOutFailed
        }
    }

    // MARK: - Manage Subscription

    func showManageSubscriptions() async {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            print("Unable to get the current window scene")
            return
        }

        do {
            try await AppStore.showManageSubscriptions(in: windowScene)
        } catch {
            print("Failed to show manage subscriptions page: \(error.localizedDescription)")
        }
    }

    // MARK: - Delete Account

    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else { return }

        do {
            // Delete all user logs
            let logsRef = Firestore.firestore().collection("items")
            let userLogs = try await logsRef.whereField("userId", isEqualTo: user.uid).getDocuments()

            // Batch delete all logs
            let batch = Firestore.firestore().batch()
            for document in userLogs.documents {
                batch.deleteDocument(document.reference)
            }
            try await batch.commit()

            // Delete user document
            let userRef = Firestore.firestore().collection("users").document(user.uid)
            try await userRef.delete()

            // Delete Firebase Auth account
            try await user.delete()

            // Sign out after successful deletion
            try Auth.auth().signOut()
        } catch {
            // If there's an error, attempt to sign out anyway
            try? Auth.auth().signOut()
            throw error
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
        case let .signInWithAppleFailed(message):
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
        case let .custom(message):
            return message
        }
    }
}
