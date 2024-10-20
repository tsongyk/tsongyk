//
//  DrillViewController.swift
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

class DrillViewController: UIViewController {
    //Create a reference to the AppDelegate:
    var appDelegate: AppDelegate?
    // Reference to the singleton model object:
    var myModelRef: ChessEngine?
    
    var moveOrderr = [ChessPiece]()
    var testVariations: [Variation] = [Variation]()
    
    var timer: Timer?
    var countDown : Int = 0
    
    var chessEngine: ChessEngine = ChessEngine()
    
    @IBOutlet weak var boardView: BoardView!
    
    var imageView: UIImageView!
    
    
    var startDrillButton = UIButton(type: .system)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(self.refreshFields(_:)),
        name: UserDefaults.didChangeNotification,
        object: nil)
        
        testVariations = FavoritesViewController().fetchFavoriteVariations()
        
        if (testVariations.isEmpty){
            startDrillButton.isEnabled = false
        }
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        chessEngine.initializeGame()
        boardView.initialPieces = chessEngine.pieces
        
        
        self.startDrillButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)

        // Do any additional setup after loading the view.
        
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        startDrillButton.setTitle("Start", for: .normal)
        startDrillButton.setTitleColor(.black, for: .normal)
        view.addSubview(startDrillButton)
        startDrillButton.translatesAutoresizingMaskIntoConstraints = false
        startDrillButton.layer.borderWidth = 2
        startDrillButton.configuration = config
        startDrillButton.layer.borderColor = UIColor.black.cgColor
        startDrillButton.layer.cornerRadius = 20

    
        NSLayoutConstraint.activate([
            startDrillButton.topAnchor.constraint(equalTo: boardView.layoutMarginsGuide.bottomAnchor, constant: 50),
            startDrillButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0),
            startDrillButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        
        
    }
    @objc func didTapButton(){
        let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "QuizDrillViewController") as! QuizDrillViewController
        self.navigationController?.pushViewController(storyboard, animated: true)
//        self.present(vc, animated: true, completion: nil)
        print("Start Tapped")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        refresh()
        
        testVariations = FavoritesViewController().fetchFavoriteVariations()
        
        if (testVariations.isEmpty){
            startDrillButton.isEnabled = false
        } else {
            startDrillButton.isEnabled = true
        }
        
        chessEngine.initializeGame()
        boardView.initialPieces = chessEngine.pieces
        
        if (boardView.changeStatus){
            boardView.resetPieces()
        }
        boardView.index = 0
        
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

