//
//  LoginView.swift
//  ChessSwiftUI
//
//  Created by Vivian Phung on 4/26/23.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var signInWithAppleManager: SignInWithAppleManager
    
    var body: some View {
        if signInWithAppleManager.isSignedIn {
            LobbyView()
        } else {
            SignInWithAppleButton(.signIn, onRequest: { request in
                signInWithAppleManager.prepareRequest(request)
            }, onCompletion: { result in
                signInWithAppleManager.handleAuthorization(result)
            })
            .frame(width: 280, height: 45)
            .padding(.bottom, 16)
        }
    }
}

