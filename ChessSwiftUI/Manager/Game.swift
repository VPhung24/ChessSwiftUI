//
//  Game.swift
//  ChessSwiftUI
//
//  Created by Vivian Phung on 4/28/23.
//

import Foundation
import FirebaseFirestore

enum GameType: String, CaseIterable {
    case blitz5 = "5 min Blitz"
    case blitz10 = "10 min Blitz"
    case tournament = "Tournament"
}

class Game: ObservableObject {
    var gameType: GameType
    var players: [Player]
    var chessBoard: ChessBoard
    
    private var gameRoomListener: ListenerRegistration?

    init(gameType: GameType, players: [Player]) {
        self.gameType = gameType
        self.players = players
        self.chessBoard = ChessBoard()
    }
}

extension Game {
    func movePiece(from source: Coordinate, to destination: Coordinate) -> Bool {
        // Use the chessBoard instance to move the piece and check for valid moves.
        if chessBoard.isValidMove(from: (source.col, source.row), to: (destination.col, destination.row)) {
            chessBoard.movePiece(from: (source.col, source.row), to: (destination.col, source.row))
            return true
        }
        return false
    }

    func isKingInCheck(for color: ChessPiece.PieceColor) -> Bool {
        // Use the chessBoard instance to check if the king is in check.
        return chessBoard.isKingInCheck(color: color)
    }

    func isCheckmate(for color: ChessPiece.PieceColor) -> Bool {
        // Use the chessBoard instance to check if there is a checkmate.
        return chessBoard.isCheckmate(color: color)
    }
    
    func startListeningForUpdates(gameRoomId: String) {
        let db = Firestore.firestore()

        gameRoomListener = db.collection("gameRooms").document(gameRoomId).addSnapshotListener { document, error in
            if let document = document, document.exists {
                // Update the local game state based on the document data.
                let boardState = document.get("boardState") as? [String: Any] ?? [:]
                self.chessBoard.importState(state: boardState)
            } else {
                print("Error fetching game room updates: \(error?.localizedDescription ?? "No data")")
            }
        }
    }

    func stopListeningForUpdates() {
        gameRoomListener?.remove()
    }
}

func createGameRoom(game: Game, completion: @escaping (String?) -> Void) {
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil

    ref = db.collection("gameRooms").addDocument(data: [
        "gameType": game.gameType.rawValue,
        "players": game.players.map { $0.id.uuidString },
        "boardState": game.chessBoard.exportState()
    ]) { error in
        if let error = error {
            print("Error adding game room: \(error.localizedDescription)")
            completion(nil)
        } else {
            print("Game room added with ID: \(ref!.documentID)")
            completion(ref!.documentID)
        }
    }
}

func joinGameRoom(gameRoomId: String, completion: @escaping (Game?) -> Void) {
    let db = Firestore.firestore()

    db.collection("gameRooms").document(gameRoomId).getDocument { document, error in
        if let document = document, document.exists {
            // Parse the document data into a Game instance.
            let gameType = GameType(rawValue: document.get("gameType") as? String ?? "") ?? .blitz5
            let players = (document.get("players") as? [Player] ?? []).map { value in Player(id: value.id, name: value.name, rating: value.rating) }
            let boardState = document.get("boardState") as? [String: Any] ?? [:]

            let game = Game(gameType: gameType, players: players)
            game.chessBoard.importState(state: boardState)

            completion(game)
        } else {
            print("Error fetching game room: \(error?.localizedDescription ?? "No data")")
            completion(nil)
        }
    }
}

func sendMoveUpdate(chessBoard: ChessBoard, gameRoomId: String, from source: Coordinate, to destination: Coordinate) {
    let db = Firestore.firestore()
    
    // Move the piece locally and update the board state.
    if chessBoard.isValidMove(from: (source.col, source.row), to: (destination.col, destination.row)) {
        let boardState = chessBoard.exportState()

        // Update the board state in the game room.
        db.collection("gameRooms").document(gameRoomId).updateData([
            "boardState": boardState
        ]) { error in
            if let error = error {
                print("Error updating board state: \(error.localizedDescription)")
            } else {
                print("Board state updated successfully")
            }
        }
    } else {
        print("Invalid move")
    }
}
