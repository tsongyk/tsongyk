//
//  ChessPieces.swift
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

struct ChessPiece: Hashable {
    let ID : Int
    let col: Int
    let row: Int
    let prevCol: Int
    let prevRow: Int
    let imageName: String
    var signal: Bool // Has this chess piece moved from its initial position?
    
    
    mutating func changeSignal() {
        signal = true
    }
}



