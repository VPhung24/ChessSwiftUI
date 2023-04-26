//
//  ChessBoardView.swift
//  ChessSwiftUI
//
//  Created by Vivian Phung on 4/26/23.
//

import SwiftUI

struct ChessBoardView: View {
    @State private var chessBoard = ChessBoard()
    @State private var selectedPiece: ChessPiece? = nil
    @State private var selectedPiecePosition: (Int, Int)? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<8, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<8, id: \.self) { col in
                        ZStack {
                            Rectangle()
                                .fill((row + col) % 2 == 0 ? Color.white : Color.gray)
                            
                            if let piece = chessBoard.board[row][col] {
                                ChessPieceView(piece: piece)
                            }
                            
                            if let selectedPiecePosition = selectedPiecePosition,
                               chessBoard.getPossibleMoves(for: selectedPiece!, at: selectedPiecePosition).contains(where: { $0 == (row, col) }) {
                                Circle()
                                    .fill(Color.blue.opacity(0.3))
                                    .frame(width: 30, height: 30)
                            }
                        }
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            handleTap(row: row, col: col)
                        }
                    }
                }
            }
        }
    }
    
    private func handleTap(row: Int, col: Int) {
        let tappedSquare = (row, col)
        let tappedPiece = chessBoard.board[row][col]
        
        if let selectedPiece = selectedPiece, let selectedPiecePosition = selectedPiecePosition {
            if chessBoard.isValidMove(from: selectedPiecePosition, to: tappedSquare) {
                chessBoard.movePiece(from: selectedPiecePosition, to: tappedSquare)
                self.selectedPiece = nil
                self.selectedPiecePosition = nil
            } else if tappedPiece?.color == selectedPiece.color {
                self.selectedPiece = tappedPiece
                self.selectedPiecePosition = tappedSquare
            } else {
                self.selectedPiece = nil
                self.selectedPiecePosition = nil
            }
        } else if tappedPiece != nil {
            selectedPiece = tappedPiece
            selectedPiecePosition = tappedSquare
        }
    }
}


