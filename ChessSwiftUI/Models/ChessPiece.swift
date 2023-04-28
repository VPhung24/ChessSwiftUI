//
//  ChessPiece.swift
//  ChessSwiftUI
//
//  Created by Vivian Phung on 4/26/23.
//

import Foundation

struct ChessPiece {
    enum PieceType: String {
        case king, queen, rook, bishop, knight, pawn
    }
    
    enum PieceColor: String {
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
