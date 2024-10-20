//
//  QuizDrillViewController.swift
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
import CoreData

class QuizDrillViewController: UIViewController {
    
    //Create a reference to the AppDelegate:
    var appDelegate: AppDelegate?
    // Reference to the singleton model object:
    var myModelRef: ChessEngine?
    
    
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
    
    // ### Timers
    var timer: Timer? // Game Timer
    var preTimer: Timer? // "Ready, Set, Go!" Timer
    var enableButtonTimer: Timer? // Enables the multiple choice buttons whenever the opening is finished playing
    
    var preTimerCountDown: Int = 0 // Used to set "Ready, Set, Go"
    var timerCountDown: Int = 61 // Used to display the game clock
    var countDown: Int = 0 // Used to enable buttons
    
    // Indexes - Used to access elements of an array
    var i: Int = 0
    var x: Int = 0
    
    
    var score: Int = 0 // Stores the score of the game. var score is incremented if the user answers correctly. Otherwise, do nothing.
    
    var moveSequence: [String] = [String]() // Determines the sequence of the tested opening.
    
    var variation: Variation? // Used to find the notations of the variation inside Core Data.
    
    var chessOpenings = ["Ruy Lopez","Petrov Defense", "Sicilian Defense","Caro-Kann","Queen's Gambit Declined","Nimzo-Indian Defense",
    "The Catalan Opening", "The Slav Defense", "Reti Opening", "English Opening"]
    
    var testVariations: [Variation] = [Variation]() // testVariations is used to fetch the user's favorite variations and is used to test the user's memory.
    
    var randomAnswerChoices: [String] = [String]() // A collection of chess openings that is used to generate random multiple choice answers
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var boardView: BoardView!
    
    @IBOutlet weak var answerA: UIButton!
    
    @IBOutlet weak var answerB: UIButton!
    
    @IBOutlet weak var answerC: UIButton!
    
    @IBOutlet weak var answerD: UIButton!
    
    var answerButtons : [UIButton] = []
    
    var chessEngine: ChessEngine = ChessEngine()
    
    
    // ### TIMERS
    private func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        nextGame(i) // Generate the next "question"
    }
    
    private func readySetGo() {
        self.preTimerCountDown = 4
        self.preTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(readySetGoTimer), userInfo: nil, repeats: true)
    }
    
    private func enableTimer() {
        self.enableButtonTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(enableButton), userInfo: nil, repeats: true)
    }
    
    // ### TIMER Functions
    
    @objc func fireTimer() {
        timerCountDown -= 1

        if timerCountDown == 0 {
            timer?.invalidate()
            let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "ResultsViewController") as! ResultsViewController
            self.navigationController?.pushViewController(storyboard, animated: true)
            //self.present(storyboard, animated: true, completion: nil)
        } else {
            self.timerLabel.text = self.timeFormatted(self.timerCountDown) // will show timer
        }
    }
    
    @objc func readySetGoTimer() {
        preTimerCountDown -= 1

        if preTimerCountDown == 0 {
            preTimer?.invalidate()
            startTimer()
        } else {
            let readySetGo: [String] = ["Ready?", "Set,", "Go!"]
            self.timerLabel.text = readySetGo[x]
            x += 1
        }
    }
    
    @objc func enableButton(){
        countDown -= 1
        if (countDown == 0){
            for button in answerButtons {
                button.isEnabled = true
            }
            enableButtonTimer?.invalidate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        answerButtons = [answerA, answerB, answerC, answerD]
        
        testVariations = FavoritesViewController().fetchFavoriteVariations() // Fetch the variations from the TableView inside FavoritesVC
        
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(self.refreshFields(_:)),
        name: UserDefaults.didChangeNotification,
        object: nil)
        // Used to customize the timer based on the difficulty set by setting preferences.
        
        // Resets the board and sets it up for next opening
        chessEngine.initializeGame()
        boardView.initialPieces = chessEngine.pieces
        if (boardView.changeStatus){
            boardView.resetPieces()
        }
        boardView.index = 0
        
        
        self.scoreLabel.text = "Score: 0"

        concatenateOpeningVariation(chessOpening: chessOpenings)
        
        randomizeAnswers()
        
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.myModelRef = self.appDelegate?.theModel
        
    }
    
    func abstractAnswer(){
        moveSequence.removeAll()
        myModelRef?.quizResult += 1
        score = myModelRef?.quizResult ?? 0
        scoreLabel.text = "Score: \(score)"
        i += 1
        if (i >= testVariations.count){
            timerCountDown = 1
        } else {
            nextGame(i)
            randomizeAnswers()
        }
    }
    
    func disableButtons(){
        for button in answerButtons{
            button.isEnabled = false
        }
    }
    
    @IBAction func answer1(_ sender: UIButton) {
        let buttonTitle = sender.title(for: .normal)!
        
        let openingName = testVariations[i].opening?.name ?? "Unknown Opening"
        let variationName = testVariations[i].name ?? "Unknown Variation"
        
        let answerName = openingName + ": " + variationName
        
        if (answerName == buttonTitle){ // IF the answer is correct
            randomAnswerChoices.append(answerName)
            myModelRef?.rightAnswer.append(answerName)
            abstractAnswer()
        } else { // If the answer is wrong
            i += 1 // Move on to the next chess opening
            myModelRef?.wrongAnswer.append(answerName)
            if (i >= testVariations.count){
                timerCountDown = 1
            } else {
                resetBoard()
                nextGame(i)
                randomizeAnswers()
            }
        }
    }
    
    //
    
    @IBAction func answer2(_ sender: UIButton) {
        let buttonTitle = sender.title(for: .normal)!
        let openingName = testVariations[i].opening?.name ?? "Unknown Opening"
        let variationName = testVariations[i].name ?? "Unknown Variation"
        let answerName = openingName + ": " + variationName
        
        if (answerName == buttonTitle){
            randomAnswerChoices.append(answerName)
            myModelRef?.rightAnswer.append(answerName)
            abstractAnswer()

        } else {
            i += 1
            myModelRef?.wrongAnswer.append(answerName)
            if (i >= testVariations.count){
                timerCountDown = 1
            } else {
                resetBoard()
                nextGame(i)
                randomizeAnswers()
            }
        }
    }
    
    @IBAction func answer3(_ sender: UIButton) {
        let buttonTitle = sender.title(for: .normal)!
        let openingName = testVariations[i].opening?.name ?? "Unknown Opening"
        let variationName = testVariations[i].name ?? "Unknown Variation"
        let answerName = openingName + ": " + variationName
        
        if (answerName == buttonTitle){
            randomAnswerChoices.append(answerName)
            myModelRef?.rightAnswer.append(answerName)
            abstractAnswer()
        } else {
            i += 1
            myModelRef?.wrongAnswer.append(answerName)
            if (i >= testVariations.count){
                timerCountDown = 1
            } else {
                resetBoard()
                nextGame(i)
                randomizeAnswers()
            }
        }
    }
    
    @IBAction func answer4(_ sender: UIButton) {
        let buttonTitle = sender.title(for: .normal)!
        let openingName = testVariations[i].opening?.name ?? "Unknown Opening"
        let variationName = testVariations[i].name ?? "Unknown Variation"
        let answerName = openingName + ": " + variationName
        
        if (answerName == buttonTitle){
            randomAnswerChoices.append(answerName)
            myModelRef?.rightAnswer.append(answerName)
            abstractAnswer()
        } else {
            i += 1
            myModelRef?.wrongAnswer.append(answerName)
            if (i >= testVariations.count){
                timerCountDown = 1
            } else {
                resetBoard()
                nextGame(i)
                randomizeAnswers()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        refresh() // Refresh in case user makes changes to the color of the board or game difficulty
        
        for button in answerButtons {
            button.isEnabled = false
        }
        
        score = 0
        
        readySetGo()
        print("Quiz just started")
        
        
    }
    

    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "Time: %02d:%02d", minutes, seconds)
    }
    
    
    /// Start Process : Fetch all the chess openings inside Core Data
    
    func fetchVariations(forOpeningWithName name: String) -> [Variation] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Opening> = Opening.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let openings = try context.fetch(fetchRequest)
            //print("Fetched openings: \(openings)")
            let variations = openings.first?.variations?.allObjects as? [Variation] ?? []
            //print("Fetched variations: \(variations)")
            return variations
        } catch {
            print("error fetching variations for opening: \(name)")
            return []
        }
    }
    
    func concatenateOpeningVariation(chessOpening: [String]){
        for opening in chessOpening {
            let variations = fetchVariations(forOpeningWithName: opening)
            
            for variation in variations {
                let openingName = String(opening)
                let variationName = variation.name!
                let answerName = openingName + ": " + variationName
                randomAnswerChoices.append(answerName)
            }
        }
    }
    
    /// End Process
    
    /// Start Process: Fetch favorite chess openings inside Core Data
    func fetchVariationMoves(named name: String) {
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
    
    /// End Process
    
    
    /// Purpose: To generate the next "question"
    func nextGame(_ i: Int){
        disableButtons()
        if (i < testVariations.count){
            if (!testVariations.isEmpty){
                let variation = testVariations[i].name ?? "Unknown Variation"
                fetchVariationMoves(named: variation) // Determines the sequence of moves of the test variation
                
                if (boardView.initialPieces.isEmpty &&
                    boardView.arrOfPieces.isEmpty){
                    updateMoves(openingVariation: moveSequence)
                } else {
                    chessEngine.initializeGame()
                    boardView.initialPieces = chessEngine.pieces
                    
                    if (boardView.changeStatus) { // If the board has changed, reset the board
                        boardView.resetPieces()
                    }
                    boardView.index = 0
                    updateMoves(openingVariation: moveSequence) // Apply changes to the boardView
                }
                boardView.animatePieces() // Start the movements
            }
        }
        enableTimer() // Start the timer for enabling the multiple choice buttons
    }
    
    
    func randomizeAnswers(){
        
        answerA.setTitle("Answer A", for: .normal)
        answerB.setTitle("Answer B", for: .normal)
        answerC.setTitle("Answer C", for: .normal)
        answerD.setTitle("Answer D", for: .normal)
        
        let openingName = testVariations[i].opening?.name ?? "Unknown Opening"
        let variationName = testVariations[i].name ?? "Unknown Variation"
        let answerName = openingName + ": " + variationName
        
        answerButtons[Int.random(in: 0..<3)].setTitle(answerName, for: .normal)
        randomAnswerChoices = randomAnswerChoices.filter(){$0 != answerName}
        var answerChoice: String = randomAnswerChoices[Int.random(in: 0..<randomAnswerChoices.count)]
        var recordedChoice: String = ""
        for button in answerButtons {
            if (button.currentTitle! != answerName){
                answerChoice = randomAnswerChoices[Int.random(in: 0..<randomAnswerChoices.count)]
                if (answerChoice == recordedChoice){
                    while (answerChoice != recordedChoice){
                        answerChoice = randomAnswerChoices[Int.random(in: 0..<randomAnswerChoices.count)]
                    }
                    button.setTitle(answerChoice, for: .normal)
                    recordedChoice = answerChoice
                } else {
                    button.setTitle(answerChoice, for: .normal)
                    recordedChoice = answerChoice
                }
            }
        }
    }
    
    // Takes moveSequence, dissects it into individual moves, and apply them to the boardView
    func updateMoves(openingVariation: [String]){
        chessEngine.resetMoveOrder()
        for i in stride(from: 0, to: openingVariation.count, by: 2) {
            chessEngine.movePiece(from: openingVariation[i], to: openingVariation[i + 1])
        }
        boardView.initialPieces = chessEngine.pieces
        boardView.arrOfPieces = chessEngine.moveOrder
        countDown = chessEngine.moveOrder.count + 1
    }
    
    func resetBoard(){
        moveSequence.removeAll()
        chessEngine.initializeGame()
        boardView.initialPieces = chessEngine.pieces
        boardView.index = 0
        if (boardView.changeStatus){
            boardView.resetPieces()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
        
        resetBoard()
        
        myModelRef?.quizResult = 0
    }
    
    @objc func refreshFields(_ notification: Notification) {
        let myDefaults = UserDefaults.standard
        
        let color: String = myDefaults.string(forKey: colorKey) ?? "blue"
        let boardColor = colorBoard[color]
        boardView.color = boardColor ?? UIColor.blue
        
        let gameDifficulty: Int = myDefaults.integer(forKey: gameDifficultyKey)
        print(gameDifficulty)
        if (gameDifficulty == 1) {
            self.timerCountDown = 91
        }
        if (gameDifficulty == 2) {
            self.timerCountDown = 61
        }
        if (gameDifficulty == 3) {
            self.timerCountDown = 31
        }

    }
    
    func refresh() {
        let myDefaults = UserDefaults.standard
        
        let color: String = myDefaults.string(forKey: colorKey) ?? "blue"
        let boardColor = colorBoard[color]
        boardView.color = boardColor ?? UIColor.blue
        
        let gameDifficulty: Int = myDefaults.integer(forKey: gameDifficultyKey)
        print(gameDifficulty)
        if (gameDifficulty == 1) {
            self.timerCountDown = 91
        }
        if (gameDifficulty == 2) {
            self.timerCountDown = 61
        }
        if (gameDifficulty == 3) {
            self.timerCountDown = 31
        }

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


