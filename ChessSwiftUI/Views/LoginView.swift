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
        VStack {
            if signInWithAppleManager.isSignedIn {
                VStack {
                    Text("Welcome")
                        .font(.largeTitle)

                    if signInWithAppleManager.isSignedIn {
                        NavigationLink(destination: LobbyView()) {
                            VStack {
                                LobbyView()
                            }
                        }
                    }
                }
            } else {
                VStack {
                    Text("Sign in")
                        .font(.headline)

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
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
