//
//  ChessModel.swift
//  ChessSwiftUI
//
//  Created by Vivian Phung on 4/26/23.
//

import Foundation

struct ChessPiece {
    enum PieceType {
        case king, queen, rook, bishop, knight, pawn
    }
    
    enum PieceColor {
        case white, black
    }
    
    let type: PieceType
    let color: PieceColor
}

extension ChessPiece {
    var imageName: String {
        return "\(color)_\(type)"
    }
}

struct ChessBoard {
    var board: [[ChessPiece?]]
    
    init() {
        board = Array(repeating: Array(repeating: nil, count: 8), count: 8)
        
        for col in 0..<8 {
            board[1][col] = ChessPiece(type: .pawn, color: .black)
            board[6][col] = ChessPiece(type: .pawn, color: .white)
        }
        
        let pieceTypes: [ChessPiece.PieceType] = [.rook, .knight, .bishop, .queen, .king, .bishop, .knight, .rook]
        for (col, pieceType) in pieceTypes.enumerated() {
            board[0][col] = ChessPiece(type: pieceType, color: .black)
            board[7][col] = ChessPiece(type: pieceType, color: .white)
        }
    }
}

extension ChessBoard {
    func isValidMove(from: (Int, Int), to: (Int, Int)) -> Bool {
        guard let piece = board[from.0][from.1] else { return false }
        
        // Check if the destination is within the bounds of the board.
        if to.0 < 0 || to.0 >= 8 || to.1 < 0 || to.1 >= 8 {
            return false
        }
        
        // Check if the destination is empty or contains an enemy piece.
        if let destinationPiece = board[to.0][to.1] {
            if destinationPiece.color == piece.color {
                return false
            }
        }
        
        let deltaX = abs(to.0 - from.0)
        let deltaY = abs(to.1 - from.1)
        
        switch piece.type {
        case .king:
            return (deltaX <= 1 && deltaY <= 1)
            
        case .queen:
            return (deltaX == 0 || deltaY == 0 || deltaX == deltaY) && isPathClear(from: from, to: to)
            
        case .rook:
            return (deltaX == 0 || deltaY == 0) && isPathClear(from: from, to: to)
            
        case .bishop:
            return (deltaX == deltaY) && isPathClear(from: from, to: to)
            
        case .knight:
            return (deltaX == 1 && deltaY == 2) || (deltaX == 2 && deltaY == 1)
            
        case .pawn:
            let direction = piece.color == .white ? -1 : 1
            let startRow = piece.color == .white ? 6 : 1
            let isCapture = board[to.0][to.1] != nil
            
            if from.0 == startRow && deltaY == 2 && deltaX == 0 && !isCapture && isPathClear(from: from, to: to) {
                return true
            }
            
            return deltaY == 1 && ((isCapture && deltaX == 1) || (!isCapture && deltaX == 0)) && from.0 + direction == to.0
        }
    }
    
    func isPathClear(from: (Int, Int), to: (Int, Int)) -> Bool {
        let deltaX = to.0 - from.0
        let deltaY = to.1 - from.1
        let stepX = deltaX == 0 ? 0 : deltaX / abs(deltaX)
        let stepY = deltaY == 0 ? 0 : deltaY / abs(deltaY)
        
        var currentPosition = (from.0 + stepX, from.1 + stepY)
        
        while currentPosition != to {
            if board[currentPosition.0][currentPosition.1] != nil {
                return false
            }
            currentPosition = (currentPosition.0 + stepX, currentPosition.1 + stepY)
        }
        
        return true
    }
    
    mutating func movePiece(from: (Int, Int), to: (Int, Int)) {
        guard isValidMove(from: from, to: to) else { return }
        
        let piece = board[from.0][from.1]
        board[from.0][from.1] = nil
        board[to.0][to.1] = piece
    }
    
    func isKingInCheck(color: ChessPiece.PieceColor) -> Bool {
        guard let kingPosition = findKingPosition(color: color) else { return false }
        
        for row in 0..<8 {
            for col in 0..<8 {
                if let piece = board[row][col], piece.color != color {
                    let from = (row, col)
                    if isValidMove(from: from, to: kingPosition) {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    func findKingPosition(color: ChessPiece.PieceColor) -> (Int, Int)? {
        for row in 0..<8 {
            for col in 0..<8 {
                if let piece = board[row][col], piece.type == .king, piece.color == color {
                    return (row, col)
                }
            }
        }
        
        return nil
    }
    
    
    func getPossibleMoves(for piece: ChessPiece, at position: (Int, Int)) -> [(Int, Int)] {
        var moves: [(Int, Int)] = []
        
        for row in 0..<8 {
            for col in 0..<8 {
                let destination = (row, col)
                if isValidMove(from: position, to: destination) {
                    moves.append(destination)
                }
            }
        }
        
        return moves
    }
    
    func isCheckmate(color: ChessPiece.PieceColor) -> Bool {
        if !isKingInCheck(color: color) {
            return false
        }
        
        for row in 0..<8 {
            for col in 0..<8 {
                if let piece = board[row][col], piece.color == color {
                    let from = (row, col)
                    let possibleMoves = getPossibleMoves(for: piece, at: from)
                    
                    for move in possibleMoves {
                        var boardCopy = self
                        boardCopy.movePiece(from: from, to: move)
                        if !boardCopy.isKingInCheck(color: color) {
                            return false
                        }
                    }
                }
            }
        }
        
        return true
    }
}
