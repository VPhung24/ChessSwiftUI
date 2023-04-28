//
//  ChessBoardTests.swift
//  ChessSwiftUITests
//
//  Created by Vivian Phung on 4/28/23.
//

import XCTest
@testable import ChessSwiftUI

final class ChessBoardTests: XCTestCase {

    func testInitialBoardSetup() {
        let chessBoard = ChessBoard()
        
        // Test that pawns are set up correctly
        for col in 0..<8 {
            XCTAssertEqual(chessBoard.getPiece(at: Coordinate(row: 6, col: col))?.type, .pawn)
            XCTAssertEqual(chessBoard.getPiece(at: Coordinate(row: 6, col: col))?.color, .white)
            XCTAssertEqual(chessBoard.getPiece(at: Coordinate(row: 1, col: col))?.type, .pawn)
            XCTAssertEqual(chessBoard.getPiece(at: Coordinate(row: 1, col: col))?.color, .black)
        }
        
        // Test other pieces and add more assertions for the initial board setup
    }

    func testExportAndImportState() {
        let chessBoard = ChessBoard()
        let initialState = chessBoard.exportState()
        
        // Create a new ChessBoard and import the initialState
        var newChessBoard = ChessBoard()
        newChessBoard.importState(state: initialState)
        
        // Compare the pieces on both boards to ensure they are the same
        for row in 0..<8 {
            for col in 0..<8 {
                let originalPiece = chessBoard.getPiece(at: Coordinate(row: row, col: col))
                let newPiece = newChessBoard.getPiece(at: Coordinate(row: row, col: col))
                XCTAssertEqual(originalPiece?.type, newPiece?.type)
                XCTAssertEqual(originalPiece?.color, newPiece?.color)
            }
        }
    }
    
    func testIsValidMove() {
        let chessBoard = ChessBoard()

        // Test valid and invalid moves for various pieces.
        // For example, test a valid pawn move:
        XCTAssertTrue(chessBoard.isValidMove(from: (1, 0), to: (2, 0)), "Valid pawn move failed")

        // Test an invalid pawn move:
        XCTAssertFalse(chessBoard.isValidMove(from: (6, 0), to: (3, 0)), "Invalid pawn move did not fail")
    }
    
    func testMovePiece() {
        var chessBoard = ChessBoard()

        // Test moving a white pawn forward by one square
        chessBoard.movePiece(from: (6, 0), to: (5, 0))
        XCTAssertNil(chessBoard.getPiece(at: Coordinate(row: 6, col: 0)), "Pawn not removed from initial position")
        XCTAssertEqual(chessBoard.getPiece(at: Coordinate(row: 5, col: 0))?.type, .pawn)
        XCTAssertEqual(chessBoard.getPiece(at: Coordinate(row: 5, col: 0))?.color, .white)

        // Clear the path for a white rook
        chessBoard.setPiece(at: (7, 0), piece: nil)

        // Test moving a white rook forward by two squares
        chessBoard.movePiece(from: (7, 1), to: (5, 1))
//        XCTAssertNil(chessBoard.getPiece(at: Coordinate(row: 7, col: 1)), "Rook not removed from initial position")
//        XCTAssertEqual(chessBoard.getPiece(at: Coordinate(row: 5, col: 1))?.type, .rook)
//        XCTAssertEqual(chessBoard.getPiece(at: Coordinate(row: 5, col: 1))?.color, .white)
    }
}
