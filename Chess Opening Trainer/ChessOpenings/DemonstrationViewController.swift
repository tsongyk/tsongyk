//
//  DemonstrationViewController.swift
//  ChessOpenings
//
//  Created by Justin Rogers on 4/13/24.
//
/*
 Submission Date: 26 April 2024
 Justin Rogers, rogerju@iu.edu
 Tommy Song, songtom@iu.edu
 
 iOS App Name: ChessOpenings
 */

import UIKit
import CoreData

class DemonstrationViewController: UIViewController {
    
    var favoritesButton: UIBarButtonItem?
    var variationName: String?
    var variation: Variation?

    var moveSequence: [String] = [String]()
    
    var boardView: BoardView!
    
    
    var chessEngine = ChessEngine()
    var timer: Timer?
    var countDown : Int = 0
    
    var startDemoButton = UIButton(type: .system)
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(enableButton), userInfo: nil, repeats: true)
    }
    
    @objc func enableButton(){
        countDown -= 1
        print(countDown)
        if (countDown == 0){
            startDemoButton.isEnabled = true
            startDemoButton.setTitle("Show Again", for: .normal)
            timer?.invalidate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(self.refreshFields(_:)),
        name: UserDefaults.didChangeNotification,
        object: nil)
        
        boardView = BoardView()
        boardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boardView)
        
        NSLayoutConstraint.activate([
            boardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            boardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            boardView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            boardView.heightAnchor.constraint(equalTo: boardView.widthAnchor)
            
        ])
        
        chessEngine.initializeGame()
        boardView.initialPieces = chessEngine.pieces
        
        self.startDemoButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        startDemoButton.setTitle("Show", for: .normal)
        startDemoButton.setTitleColor(.black, for: .normal)
        startDemoButton.translatesAutoresizingMaskIntoConstraints = false
        startDemoButton.layer.borderWidth = 2
        startDemoButton.configuration = config
        startDemoButton.layer.borderColor = UIColor.black.cgColor
        startDemoButton.layer.cornerRadius = 20
        view.addSubview(startDemoButton)
        
        
        NSLayoutConstraint.activate([
            startDemoButton.topAnchor.constraint(equalTo: boardView.layoutMarginsGuide.bottomAnchor, constant: 50),
            startDemoButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0),
            startDemoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        
        if let variationName = variationName {
            self.title = variationName
            fetchVariation(named: variationName)
        }
        updateFavoriteButton()
        // Do any additional setup after loading the view.
    }
    
    @objc func didTapButton(){
        print("move tapped")
        startTimer()
        if (boardView.initialPieces.isEmpty &&
            boardView.arrOfPieces.isEmpty){
            updateMoves(openingVariation: moveSequence)
        } else {
            chessEngine.initializeGame()
            boardView.initialPieces = chessEngine.pieces
            if (boardView.changeStatus){
                boardView.resetPieces()
            }
            boardView.index = 0
            updateMoves(openingVariation: moveSequence)
        }
        
        startDemoButton.isEnabled = false
        
        boardView.animatePieces()
    }
    
    let moveNotations: [String: String] = [
        "RLE2E4": "e2e4",
        "RLE7E5": "e7e5",
        "RLG1F3": "g1f3",
        "RLB8C6": "b8c6",
        "RLF1B5": "f1b5",
        
        "PDE2E4": "e2e4",
        "PDE7E5": "e7e5",
        "PDG1F3": "g1f3",
        "PDG8F6": "g8f6",
        "PDD2D4": "d2d4",
        
        "SDE2E4": "e2e4",
        "SDC7C5": "c7c5",
        "SDG1F3": "g1f3",
        "SDD7D6": "d7d6",
        "SDD2D4": "d2d4",
        
        "CKE2E4": "e2e4",
        "CKC7C6": "c7c6",
        "CKD2D4": "d2d4",
        "CKD7D5": "d7d5",
        "CKE4D5": "e4d5",
        
        "QGDD2D4": "d2d4",
        "QGDD7D5": "d7d5",
        "QGDC2C4": "c2c4",
        "QGDE7E6": "e7e6",
        "QGDB1C3": "b1c3",
        
        "NIDD2D4": "d2d4",
        "NIDG8F6": "g8f6",
        "NIDC2C4": "c2c4",
        "NIDE7E6": "e7e6",
        "NIDB1C3": "b1c3",
        
        "TCOD2D4": "d2d4",
        "TCOG8F6": "g8f6",
        "TCOC2C4": "c2c4",
        "TCOE7E6": "e7e6",
        "TCOG2G3": "g2g3",
        
        "TSDD2D4": "d2d4",
        "TSDD7D5": "d7d5",
        "TSDC2C4": "c2c4",
        "TSDC7C6": "c7c6",
        "TSDG1F3": "g1f3",
        
        "ROG1F3": "g1f3",
        "ROD7D5": "d7d5",
        "ROC2C4": "c2c4",
        "ROD5D4": "d5d4",
        "ROE2E3": "e2e3",
        
        "EOC2C4": "c2c4",
        "EOE7E5": "e7e5",
        "EOB1C3": "b1c3",
        "EOG8F6": "g8f6",
        "EOG1F3": "g1f3",
    ]
    
    func fetchVariation(named name: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Variation> = Variation.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let variations = try context.fetch(fetchRequest)
            if let fetchedVariation = variations.first {
                self.variation = fetchedVariation
                
                let moveFetchRequest: NSFetchRequest<Move> = Move.fetchRequest()
                moveFetchRequest.predicate = NSPredicate(format: "variation == %@", fetchedVariation)
                moveFetchRequest.sortDescriptors = [NSSortDescriptor(key: "moveOrder", ascending: true)]
                
                let moveEntities = try context.fetch(moveFetchRequest)
                let moveKeys = moveEntities.compactMap { $0.notation }
                //print(moveKeys)
                processMoveNotations(moveKeys)
            }
        } catch {
            print("Error fetching variation named \(name): \(error)")
        }
    }
        
    func updateFavoriteButton() {
        let isFavorite = variation?.isFavorite ?? false
        let buttonImage = isFavorite ? "star.fill" : "star"
        favoritesButton = UIBarButtonItem(image: UIImage(systemName: buttonImage), style: .plain, target: self, action: #selector(toggleFavorite))
        self.navigationItem.rightBarButtonItem = favoritesButton
    }
        
    @objc func toggleFavorite() {
        guard let variation = variation else { return }
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        variation.isFavorite.toggle()
        do {
            try context.save()
            updateFavoriteButton()
            NotificationCenter.default.post(name: NSNotification.Name("FavoritesUpdated"), object: nil)
        } catch {
            print("Error toggling favorite status: \(error)")
        }
    }
    
    func processMoveNotations(_ notationKeys: [String]) {
        for key in notationKeys {
            if let notation = moveNotations[key] {
                let startSquare = String(notation.prefix(2))
                let endSquare = String(notation.suffix(2))
                //print("Move from \(startSquare) to \(endSquare)")
                moveSequence.append(startSquare)
                moveSequence.append(endSquare)
            }
        }
    }
    
    
    func updateMoves(openingVariation: [String]){
        chessEngine.resetMoveOrder()
        for i in stride(from: 0, to: openingVariation.count, by: 2) {
            chessEngine.movePiece(from: openingVariation[i], to: openingVariation[i + 1])
        }
        boardView.initialPieces = chessEngine.pieces
        boardView.arrOfPieces = chessEngine.moveOrder
        countDown = chessEngine.moveOrder.count + 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
        chessEngine.initializeGame()
        boardView.initialPieces = chessEngine.pieces
        if (boardView.changeStatus){
            boardView.resetPieces()
        }
        boardView.index = 0
        startDemoButton.isEnabled = true
        startDemoButton.setTitle("Show", for: .normal)
        
    }
    
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
        
        chessEngine.initializeGame()
        boardView.initialPieces = chessEngine.pieces
        if (boardView.changeStatus){
            boardView.resetPieces()
        }
        boardView.index = 0
    }
    
    @objc func refreshFields(_ notification: Notification) {
        let myDefaults = UserDefaults.standard
        let color: String = myDefaults.string(forKey: colorKey) ?? "blue"
        let boardColor = colorBoard[color]
        boardView.color = boardColor ?? UIColor.blue

    }
    
    func refresh() {
        let myDefaults = UserDefaults.standard
        let color: String = myDefaults.string(forKey: colorKey) ?? "blue"
        let boardColor = colorBoard[color]
        boardView.color = boardColor ?? UIColor.blue

    }
    
    let colorBoard: [String: UIColor] = [
        "blue" : UIColor.blue,
        "green" : UIColor.green,
        "brown" : UIColor.brown,
        "black" : UIColor.black,
        "pink" : UIColor.systemPink,
        "red" : UIColor.red
    ]
    
        
}

