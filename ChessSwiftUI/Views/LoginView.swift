//
//  LoginView.swift
//  ChessSwiftUI
//
//  Created by Vivian Phung on 4/26/23.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var signInWithAppleViewModel = SignInWithAppleViewModel()

    var body: some View {
        NavigationView {
            HStack {
                SignInWithAppleButtonView()
            }
        }
        .environmentObject(signInWithAppleViewModel)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
