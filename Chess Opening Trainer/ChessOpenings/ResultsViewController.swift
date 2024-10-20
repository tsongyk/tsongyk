//
//  ResultsViewController.swift
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

class ResultsViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    
    //Create a reference to the AppDelegate:
    var appDelegate: AppDelegate?
    // Reference to the singleton model object:
    var myModelRef: ChessEngine?
    
    var chessEngine: ChessEngine = ChessEngine()

    var score: Int = 0
    
    @IBOutlet weak var resultsTextView: UITextView!
    
    
    var backToDrillButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.myModelRef = self.appDelegate?.theModel
        
        
        self.backToDrillButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        self.backToDrillButton.setTitle("Try Again", for: .normal)
        self.backToDrillButton.setTitleColor(.black, for: .normal)
        view.addSubview(self.backToDrillButton)
        self.backToDrillButton.translatesAutoresizingMaskIntoConstraints = false
        self.backToDrillButton.layer.borderWidth = 2
        self.backToDrillButton.configuration = config
        self.backToDrillButton.layer.borderColor = UIColor.black.cgColor
        self.backToDrillButton.layer.cornerRadius = 20

    
        NSLayoutConstraint.activate([
            self.backToDrillButton.topAnchor.constraint(equalTo: resultsTextView.layoutMarginsGuide.bottomAnchor, constant: 50),
            self.backToDrillButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0),
            self.backToDrillButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])

        score = myModelRef?.quizResult ?? 0
        self.scoreLabel.text = "Score: \(score)"
        
        
    }
    

    @objc func didTapButton(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        resultsTextView.font = .systemFont(ofSize: 16)
        resultsTextView.isEditable = false
        
        resultsTextView.text = "Correct: \n"
        let correctAnswers = myModelRef!.rightAnswer
        
        if (correctAnswers.isEmpty){
            resultsTextView.text += "None\n"
        } else {
            for answer in correctAnswers {
                resultsTextView.text += "\(answer)\n"
            }
        }
        
        resultsTextView.text += "\nIncorrect: \n"
        let incorrectAnswers = myModelRef!.wrongAnswer
        if (incorrectAnswers.isEmpty) {
            resultsTextView.text += "None\n"
        } else {
            for answer in incorrectAnswers {
                resultsTextView.text += "\(answer)\n"
            }
        }
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
        
        chessEngine.initializeGame()
        myModelRef?.rightAnswer.removeAll()
        myModelRef?.wrongAnswer.removeAll()
        
        myModelRef?.quizResult = 0
    }

}


