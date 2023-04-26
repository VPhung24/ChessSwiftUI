//
//  SignInWithAppleViewModel.swift
//  ChessSwiftUI
//
//  Created by Vivian Phung on 4/26/23.
//

import AuthenticationServices
import CryptoKit

class SignInWithAppleViewModel: NSObject, ObservableObject {
    @Published var isSignedIn: Bool = false
    @Published var userId: String?
    
    private var currentNonce: String?

    func signIn() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let nonce = generateNonce()
        currentNonce = nonce
        request.nonce = nonce
        
        let authController = ASAuthorizationController(authorizationRequests: [request])
        authController.delegate = self
        authController.presentationContextProvider = self
        authController.performRequests()
    }
    
    private func generateNonce() -> String {
        return UUID().uuidString
    }
}

extension SignInWithAppleViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let _ = appleIDCredential.email, let _ = appleIDCredential.fullName {
            
            let userId = appleIDCredential.user
            // Store the userId in your app or send it to your backend
            
            DispatchQueue.main.async {
                self.userId = userId
                self.isSignedIn = true
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error
    }
}

extension SignInWithAppleViewModel: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
            fatalError("No active window scene found.")
        }
        guard let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            fatalError("No key window found.")
        }
        return window
    }
}

