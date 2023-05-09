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
    @Published var player: Player?

    func prepareRequest(_ request: ASAuthorizationAppleIDRequest) {
        // Perform any additional configuration for the request, such as setting the nonce or state.
    }

    func handleAuthorization(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                self.player = Player(id: UUID(), name: appleIDCredential.fullName?.namePrefix ?? "first name", rating: 400)
                
                DispatchQueue.main.async {
                    self.isSignedIn = true
                }
            }
        case .failure(let error):
            print("Error during Sign in with Apple: \(error.localizedDescription)")
        }
    }
}
