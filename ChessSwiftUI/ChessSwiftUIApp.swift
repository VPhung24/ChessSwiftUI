//
//  ChessSwiftUIApp.swift
//  ChessSwiftUI
//
//  Created by Vivian Phung on 4/26/23.
//

import SwiftUI

@main
struct ChessSwiftUIApp: App {
    var signInWithAppleManager = SignInWithAppleManager()

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(signInWithAppleManager)
        }
    }
}
