//
//  ChessBoardView.swift
//  ChessSwiftUI
//
//  Created by Vivian Phung on 4/26/23.
//

import SwiftUI

struct ChessBoardView: View {
    @State private var chessBoard = ChessBoard()

    var body: some View {
        VStack {
            ForEach(0..<8, id: \.self) { row in
                HStack {
                    ForEach(0..<8, id: \.self) { col in
                        ZStack {
                            Rectangle()
                                .fill((row + col) % 2 == 0 ? Color.white : Color.gray)
                            if let piece = chessBoard.board[row][col] {
                                ChessPieceView(piece: piece)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ChessPieceView: View {
    let piece: ChessPiece

    var body: some View {
        ChessBoardView()
    }
}
