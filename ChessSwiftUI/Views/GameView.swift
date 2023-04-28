//
//  GameView.swift
//  ChessSwiftUI
//
//  Created by Vivian Phung on 4/28/23.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var game: Game

    var body: some View {
        VStack {
            Text("Playing \(game.gameType.rawValue)")
                .font(.largeTitle)
            
            // Add your chessboard and game controls here.
        }
    }
}


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: Game(gameType: .blitz5, players: [Player(id: UUID(), name: "viv", rating: 150), Player(id: UUID(), name: "hello world", rating: 200)]))
    }
}
