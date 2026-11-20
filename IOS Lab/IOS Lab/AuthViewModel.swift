import Combine
import Foundation
import FirebaseAuth

@MainActor
final class AuthViewModel: ObservableObject {
    @Published private(set) var user: User?
    @Published var errorMessage: String?
    @Published var isLoading = false

    private var authListener: AuthStateDidChangeListenerHandle?

    init() {
        user = Auth.auth().currentUser
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.user = user
            }
        }
    }

    deinit {
        if let authListener {
            Auth.auth().removeStateDidChangeListener(authListener)
        }
    }

    func signIn(email: String, password: String) {
        authenticate { completion in
            Auth.auth().signIn(withEmail: email, password: password, completion: completion)
        }
    }

    func signUp(email: String, password: String) {
        authenticate { completion in
            Auth.auth().createUser(withEmail: email, password: password, completion: completion)
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func authenticate(
        action: (@escaping (AuthDataResult?, Error?) -> Void) -> Void
    ) {
        errorMessage = nil
        isLoading = true
        action { [weak self] _, error in
            Task { @MainActor in
                self?.isLoading = false
                self?.errorMessage = error?.localizedDescription
            }
        }
    }
}
