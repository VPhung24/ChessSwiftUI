//
//  LobbyView.swift
//  ChessSwiftUI
//
//  Created by Vivian Phung on 4/28/23.
//

import SwiftUI

struct LobbyView: View {
    @EnvironmentObject var signInWithAppleManager: SignInWithAppleManager

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(GameType.allCases, id: \.self) { gameType in
                        NavigationLink(destination: GameView(game: Game(gameType: gameType, players: []))) {
                            Text(gameType.rawValue)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                
            }
            .navigationBarTitle("Lobby")
        }
    }
}

struct LobbyView_Previews: PreviewProvider {
    static var previews: some View {
        LobbyView()
    }
}
