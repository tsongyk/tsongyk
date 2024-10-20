//
//  ChessEngine.swift
//  ChessOpenings
//
//  Created by Tommy Song on 4/19/24.
//
/*
 Submission Date: 26 April 2024
 Justin Rogers, rogerju@iu.edu
 Tommy Song, songtom@iu.edu
 
 iOS App Name: ChessOpenings
 */

import Foundation

class ChessEngine {
    
    // To gather data from the QuizVC and give them to ResultsVC
    var quizResult: Int = 0
    var wrongAnswer: [String] = []
    var rightAnswer: [String] = []
    
    
    var pieces: Set<ChessPiece> = Set<ChessPiece>()
    
    var notation = ["a" : 0, "b" : 1, "c" : 2, "d" : 3, "e" : 4, "f" : 5, "g" : 6, "h" : 7, "1" : 7, "2" : 6, "3" : 5, "4" : 4, "5" : 3, "6" : 2, "7" : 1, "8" : 0, ]
    
    
    var moveOrder = [ChessPiece]()
    
    func movePiece(from: String, to: String) {
        
        
        let letter = from.index(from.startIndex, offsetBy: 0)
        let num = from.index(from.startIndex, offsetBy: 1)
        
        let letter2 = to.index(from.startIndex, offsetBy: 0)
        let num2 = to.index(from.startIndex, offsetBy: 1)
        
        let colLetter : Character = from[letter]
        let fromCol = notation[String(colLetter)]
        let rowLetter : Character = from[num]
        let fromRow = notation[String(rowLetter)]
        
        let colLetter2 : Character = to[letter2]
        let toCol = notation[String(colLetter2)]
        let rowLetter2 : Character = to[num2]
        let toRow = notation[String(rowLetter2)]
        
        guard var candidate = pieceAt(col: fromCol!, row: fromRow!) else {
            return
        }
        
        candidate.changeSignal() // Initial thought: To prevent moving them again in the future.
        
        pieces.remove(candidate)
        
        pieces.insert(ChessPiece(ID: candidate.ID, col: toCol!, row: toRow!,  prevCol: fromCol!, prevRow: fromRow!, imageName: candidate.imageName, signal: candidate.signal))
        
        moveOrder.append(ChessPiece(ID: candidate.ID, col: toCol!, row: toRow!,  prevCol: fromCol!, prevRow: fromRow!, imageName: candidate.imageName, signal: candidate.signal))
    }

    // If there is a piece at the given coordinates (square), return that piece
    func pieceAt(col: Int, row: Int) -> ChessPiece? {
        for piece in pieces {
            if col == piece.col && row == piece.row {
                return piece
            }
        }
        return nil
    }
    
    func resetMoveOrder(){
        moveOrder.removeAll()
    }
    
    func initializeGame() {
        pieces.removeAll()
        
        pieces.insert(ChessPiece(ID: 0, col: 0, row: 0, prevCol: 0, prevRow: 0, imageName: "black-rook", signal: false))
        pieces.insert(ChessPiece(ID: 1, col: 1, row: 0, prevCol: 1, prevRow: 0, imageName: "black-knight", signal: false))
        pieces.insert(ChessPiece(ID: 2, col: 2, row: 0,  prevCol: 2, prevRow: 0, imageName: "black-bishop", signal: false))
        pieces.insert(ChessPiece(ID: 3, col: 3, row: 0,  prevCol: 3, prevRow: 0, imageName: "black-queen", signal: false))
        pieces.insert(ChessPiece(ID: 4, col: 4, row: 0,  prevCol: 4, prevRow: 0, imageName: "black-king", signal: false))
        pieces.insert(ChessPiece(ID: 5, col: 5, row: 0,  prevCol: 5, prevRow: 0, imageName: "black-bishop", signal: false))
        pieces.insert(ChessPiece(ID: 6, col: 6, row: 0,  prevCol: 6, prevRow: 0, imageName: "black-knight", signal: false))
        pieces.insert(ChessPiece(ID: 7, col: 7, row: 0,  prevCol: 7, prevRow: 0, imageName: "black-rook", signal: false))
        
        pieces.insert(ChessPiece(ID: 8, col: 0, row: 7,  prevCol: 0, prevRow: 7, imageName: "white-rook", signal: false))
        pieces.insert(ChessPiece(ID: 9, col: 1, row: 7,  prevCol: 1, prevRow: 7, imageName: "white-knight", signal: false))
        pieces.insert(ChessPiece(ID: 10, col: 2, row: 7,  prevCol: 2, prevRow: 7, imageName: "white-bishop", signal: false))
        pieces.insert(ChessPiece(ID: 11, col: 3, row: 7,  prevCol: 3, prevRow: 7, imageName: "white-queen", signal: false))
        pieces.insert(ChessPiece(ID: 12, col: 4, row: 7,  prevCol: 4, prevRow: 7, imageName: "white-king", signal: false))
        pieces.insert(ChessPiece(ID: 13, col: 5, row: 7,  prevCol: 5, prevRow: 7, imageName: "white-bishop", signal: false))
        pieces.insert(ChessPiece(ID: 14, col: 6, row: 7,  prevCol: 6, prevRow: 7, imageName: "white-knight", signal: false))
        pieces.insert(ChessPiece(ID: 15, col: 7, row: 7,  prevCol: 7, prevRow: 7, imageName: "white-rook", signal: false))
        
        for i in 0...7{
            pieces.insert(ChessPiece(ID: 16 + i, col: 0 + i, row: 1,  prevCol: 0 + i, prevRow: 1, imageName: "black-pawn", signal: false))
            pieces.insert(ChessPiece(ID: 24 + i, col: 0 + i, row: 6,  prevCol: 0 + i, prevRow: 6, imageName: "white-pawn", signal: false))
        }
    }
}
