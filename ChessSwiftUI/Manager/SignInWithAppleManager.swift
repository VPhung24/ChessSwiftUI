//
//  SignInWithAppleManager.swift
//  ChessSwiftUI
//
//  Created by Vivian Phung on 4/28/23.
//

import SwiftUI
import AuthenticationServices

class SignInWithAppleManager: NSObject, ObservableObject {
    @Published var isSignedIn = false
    @Published var userId = ""
    @Published var fullName = ""
    @Published var email = ""

    func prepareRequest(_ request: ASAuthorizationAppleIDRequest) {
        // Perform any additional configuration for the request, such as setting the nonce or state.
    }

    func handleAuthorization(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                self.userId = appleIDCredential.user
                self.fullName = appleIDCredential.fullName?.namePrefix ?? "first name"
                self.email = appleIDCredential.email ?? "email"
                
                // Save the user data or perform any necessary tasks, such as registering the user with your backend.
                // For demonstration purposes, we're only updating the isSignedIn property.
                DispatchQueue.main.async {
                    self.isSignedIn = true
                }
            }
        case .failure(let error):
            print("Error during Sign in with Apple: \(error.localizedDescription)")
        }
    }
}
