//
//  SignInWithAppleButtonView.swift
//  ChessSwiftUI
//
//  Created by Vivian Phung on 4/26/23.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleButtonView: UIViewRepresentable {
    @EnvironmentObject var signInWithAppleViewModel: SignInWithAppleViewModel
    
    typealias UIViewType = ASAuthorizationAppleIDButton

    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        button.addTarget(context.coordinator, action: #selector(Coordinator.signInTapped), for: .touchUpInside)
        return button
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: SignInWithAppleButtonView
        
        init(_ parent: SignInWithAppleButtonView) {
            self.parent = parent
        }
        
        @objc func signInTapped() {
            parent.signInWithAppleViewModel.signIn()
        }
    }
}

struct SignInWithAppleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithAppleButtonView()
    }
}
