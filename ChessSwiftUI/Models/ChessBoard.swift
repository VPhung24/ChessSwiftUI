//
//  ChessModel.swift
//  ChessSwiftUI
//
//  Created by Vivian Phung on 4/26/23.
//

import Foundation

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
        guard isInsideBoard(from) && isInsideBoard(to) else { return false }
        
        let movingPiece = board[from.0][from.1]
        guard let piece = movingPiece else { return false }
        
        if let targetPiece = board[to.0][to.1] {
            if targetPiece.color == piece.color {
                return false
            }
        }
        switch piece.type {
        case .pawn:
            return isValidPawnMove(from: from, to: to, piece: piece)
        case .rook:
            return isValidRookMove(from: from, to: to)
        case .knight:
            return isValidKnightMove(from: from, to: to)
        case .bishop:
            return isValidBishopMove(from: from, to: to)
        case .queen:
            return isValidQueenMove(from: from, to: to)
        case .king:
            return isValidKingMove(from: from, to: to)
        }
    }
    
    private func isInsideBoard(_ position: (Int, Int)) -> Bool {
        return position.0 >= 0 && position.0 < 8 && position.1 >= 0 && position.1 < 8
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
    
    func getPiece(at coordinate: Coordinate) -> ChessPiece? {
        return board[coordinate.row][coordinate.col]
    }
    
    mutating func setPiece(at coordinate: (Int, Int), piece: ChessPiece?) {
            board[coordinate.0][coordinate.1] = piece
        }
}

extension ChessBoard {
    private func isValidPawnMove(from: (Int, Int), to: (Int, Int), piece: ChessPiece) -> Bool {
        let direction: Int = piece.color == .white ? -1 : 1
        let oneStepForward = (from.0 + direction, from.1)
        let twoStepsForward = (from.0 + 2 * direction, from.1)
        
        if oneStepForward == to && board[to.0][to.1] == nil {
            return true
        }
        
        if twoStepsForward == to && (piece.color == .white ? from.0 == 6 : from.0 == 1) && board[oneStepForward.0][oneStepForward.1] == nil && board[twoStepsForward.0][twoStepsForward.1] == nil {
            return true
        }
        
        let captureMoves = [(from.0 + direction, from.1 - 1), (from.0 + direction, from.1 + 1)]
        
        for captureMove in captureMoves {
            if captureMove == to {
                if let targetPiece = board[to.0][to.1], targetPiece.color != piece.color {
                    return true
                }
            }
        }
        
        return false
    }
    
    private func isValidRookMove(from: (Int, Int), to: (Int, Int)) -> Bool {
        // Horizontal or vertical move
        return from.0 == to.0 || from.1 == to.1
    }
    
    private func isValidKnightMove(from: (Int, Int), to: (Int, Int)) -> Bool {
        // L-shaped move
        let rowDifference = abs(from.0 - to.0)
        let colDifference = abs(from.1 - to.1)
        return (rowDifference == 2 && colDifference == 1) || (rowDifference == 1 && colDifference == 2)
    }
    
    private func isValidBishopMove(from: (Int, Int), to: (Int, Int)) -> Bool {
        // Diagonal move
        return abs(from.0 - to.0) == abs(from.1 - to.1)
    }
    
    private func isValidQueenMove(from: (Int, Int), to: (Int, Int)) -> Bool {
        // Combination of rook and bishop moves
        return isValidRookMove(from: from, to: to) || isValidBishopMove(from: from, to: to)
    }
    
    private func isValidKingMove(from: (Int, Int), to: (Int, Int)) -> Bool {
        // One step in any direction
        let rowDifference = abs(from.0 - to.0)
        let colDifference = abs(from.1 - to.1)
        return rowDifference <= 1 && colDifference <= 1
    }
    
}

extension ChessBoard {
    func exportState() -> [String: Any] {
        var state: [String: Any] = [:]
        
        for row in 0..<8 {
            for col in 0..<8 {
                if let piece = board[row][col] {
                    let coordinate = Coordinate(row: row, col: col)
                    let pieceData: [String: Any] = [
                        "type": piece.type.rawValue,
                        "color": piece.color.rawValue
                    ]
                    state["\(coordinate.row),\(coordinate.col)"] = pieceData
                }
            }
        }
        
        return state
    }
    
    mutating func importState(state: [String: Any]) {
        // Clear the board before importing the state
        board = Array(repeating: Array(repeating: nil, count: 8), count: 8)
        
        for (coordinateString, pieceData) in state {
            let coordinates = coordinateString.split(separator: ",").map { Int($0)! }
            let row = coordinates[0]
            let col = coordinates[1]
            
            if let pieceData = pieceData as? [String: String],
               let typeString = pieceData["type"],
               let colorString = pieceData["color"],
               let type = ChessPiece.PieceType(rawValue: typeString),
               let color = ChessPiece.PieceColor(rawValue: colorString) {
                let piece = ChessPiece(type: type, color: color)
                board[row][col] = piece
            }
        }
    }
    
}
