//
//  BoardView.swift
//  ChessOpenings
//
//  Created by Tommy Song on 4/13/24.
//
/*
 Submission Date: 26 April 2024
 Justin Rogers, rogerju@iu.edu
 Tommy Song, songtom@iu.edu
 
 iOS App Name: ChessOpenings
 */

import UIKit

class BoardView: UIView, CAAnimationDelegate {
    
    var cellSide: CGFloat = 0
    var boundsWidth: CGFloat = 0
    var boundsHeight: CGFloat = 0
    
    var color: UIColor = UIColor.blue // Default Color of the chess board
    
    var timer: Timer? // Used to play one move at a time and prevent playing all the moves at the same time
    
    var changeStatus : Bool = false // Determines the status of the board. Has it changed or not?
    
    
    var initialPieces: Set<ChessPiece> = Set<ChessPiece>()
    
    var piecesViews = [Int:UIImageView]()
    
    var arrOfPieceViews = [UIImageView]()
    
    var arrOfPieces : [ChessPiece] = [ChessPiece]()
    
    
    var index : Int = 0
    
    
    // Used to play one move at a time and prevent playing all the moves at the same time
    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(stepper), userInfo: nil, repeats: true)
    }
    

    override func draw(_ rect: CGRect) {
        
        // # DEBUGGING
        boundsWidth = bounds.width // width of the UIView
        boundsHeight = bounds.height // height of the UIView
        //print(bounds.width)
        //print(bounds.height)
        
        cellSide = bounds.width / 8 // Length of one square
        
        drawBoard() // Renders the checkered board
        drawPieces() // Renders the chess pieces
        
    }
    
    
    func drawBoard(){
        for row in 0..<4 {
            for col in 0..<4 {
                drawSquare(col: col * 2, row: row * 2, color: UIColor.white)
                drawSquare(col: 1 + col * 2, row: 1 + row * 2, color: UIColor.white)
                
                drawSquare(col: 1 + col * 2, row: row * 2, color: color)
                drawSquare(col: col * 2, row: 1 + row * 2, color: color)
            }
        }
    }
    
    func drawSquare(col: Int, row: Int, color: UIColor){
        let path = UIBezierPath(rect: CGRect(x: CGFloat(col) * cellSide, y: CGFloat(row) * cellSide, width: cellSide, height: cellSide))
        color.setFill()
        path.fill()
    }
    
    func drawPieces(){
        for piece in self.initialPieces {
            
            let pieceImage = resizeImage(image: UIImage(named: piece.imageName)!, newWidth: self.cellSide)
            
            let imageView: UIImageView! = UIImageView(image: pieceImage)

            imageView.center = CGPoint(x: CGFloat(piece.col) * self.cellSide + (self.cellSide / 2), y: CGFloat(piece.row) * self.cellSide + (self.cellSide / 2)) // Makes sure the pieces are properly inside their respective squares
            
            piecesViews.updateValue(imageView, forKey: piece.ID) // Adds to piecesViews dictionary. It is useful in locating and moving a specific chess piece.
            
            addSubview(imageView)
            
        }
    }
    
    func resetPieces(){
        for piece in self.initialPieces {
            let imageView: UIImageView! = piecesViews[piece.ID]

            imageView.center = CGPoint(x: CGFloat(piece.col) * self.cellSide + (self.cellSide / 2), y: CGFloat(piece.row) * self.cellSide + (self.cellSide / 2))
            
            piecesViews.updateValue(imageView, forKey: piece.ID)
            
        }
        self.arrOfPieces.removeAll()
        self.arrOfPieceViews.removeAll()
        self.changeStatus = false
    }
    
    func animatePieces(){
        //print("Animating piece")
        self.changeStatus = true

            for piece in initialPieces {
                if piece.signal {
                    //print("moving \(piece.imageName)")
                    if let imageView = piecesViews[piece.ID] {
                        arrOfPieceViews.append(imageView)
                    }
                }
            }

            startTimer()
        }
    
    @objc func stepper() {
        
        if (index >= arrOfPieces.count - 1){
            timer?.invalidate()
        }
        if (!arrOfPieceViews.isEmpty && !arrOfPieces.isEmpty){
            
            let testPiece = arrOfPieces[index] // arrOfPieces is an array of pieces that will be moved.
            let testView = piecesViews[testPiece.ID] // Uses the piecesViews dictionary to identify the chess piece and use its assigned ImageView
            
            
            let animation = CABasicAnimation() // Implementation of Core Animation
            animation.delegate = self
            animation.keyPath = "position"
            
            let oldxCoord = CGFloat(testPiece.prevCol) * self.cellSide + (self.cellSide / 2)
            let oldyCoord = CGFloat(testPiece.prevRow) * self.cellSide + (self.cellSide / 2)
            
            print("OLD POSITION: x: \(oldxCoord) y: \(oldyCoord)")
            
            let newxCoord = CGFloat(testPiece.col) * self.cellSide + (self.cellSide / 2)
            let newyCoord = CGFloat(testPiece.row) * self.cellSide + (self.cellSide / 2)
            
            print("NEW POSITION: x: \(newxCoord) y: \(newyCoord)")
            
            let initialPosition = [oldxCoord, oldyCoord]
            let updatedPosition = [newxCoord, newyCoord]
            animation.fromValue = initialPosition
            animation.toValue = updatedPosition
            animation.duration = 0.5
            
            testView!.layer.add(animation, forKey: "piece")
            testView!.layer.position = CGPoint(x: newxCoord, y: newyCoord)
        }
        
        index += 1 // Moves on to the next chess piece
    }
    

    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {

        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }

}


