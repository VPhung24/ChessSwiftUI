//
//  ChessPieceView.swift
//  ChessSwiftUI
//
//  Created by Vivian Phung on 4/26/23.
//

import SwiftUI

struct ChessPieceView: View {
    var piece: ChessPiece
    
    var body: some View {
        Image(piece.imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct ChessPieceView_Previews: PreviewProvider {
    static var previews: some View {
        ChessPieceView(piece: ChessPiece(type: .bishop, color: .white
                                        ))
    }
}
