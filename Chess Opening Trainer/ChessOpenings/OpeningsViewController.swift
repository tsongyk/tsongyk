//
//  OpeningsViewController.swift
//  ChessOpenings
//
//  Created by Justin Rogers on 4/7/24.
//
/*
 Submission Date: 26 April 2024
 Justin Rogers, rogerju@iu.edu
 Tommy Song, songtom@iu.edu
 
 iOS App Name: ChessOpenings
 */

import UIKit

class OpeningsViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    var favoriteOpeningsButton = UIButton(type: .system)
    var chessOpenings: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ///** Label: "Openings"**
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Openings"
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        ///** Scroll View contains openings**
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20),
            scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            // Adds padding
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            // Adds padding
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            // Adds to hieght
            scrollView.heightAnchor.constraint(equalToConstant: 300)
        ])

        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10

        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            // Make sure the stack view is the same height as the scroll view
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        chessOpenings = ["Ruy Lopez","Petrov Defense", "Sicilian Defense","Caro-Kann","Queen's Gambit Declined","Nimzo-Indian Defense",
        "The Catalan Opening", "The Slav Defense", "Reti Opening", "English Opening"]

        ///** Adding chess openings to the stack view**
        // Add custom views to the stack view
        for i in chessOpenings {
            let openingView = createOpeningView(title: i)
            stackView.addArrangedSubview(openingView)
            // Width of openings
            openingView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        }
            
        
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        ///** Button: "View Favorite Openings"**
        favoriteOpeningsButton.setTitle("View Favorite Openings", for: .normal)
        favoriteOpeningsButton.setTitleColor(.black, for: .normal)
        view.addSubview(favoriteOpeningsButton)
        favoriteOpeningsButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteOpeningsButton.layer.borderWidth = 2
        favoriteOpeningsButton.configuration = config
        favoriteOpeningsButton.layer.borderColor = UIColor.black.cgColor
        favoriteOpeningsButton.layer.cornerRadius = 20
        favoriteOpeningsButton.addTarget(self, action: #selector(favoritesTapped(_:)), for: .touchUpInside)

        
        NSLayoutConstraint.activate([
            favoriteOpeningsButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 40),
            favoriteOpeningsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    ///** Button: "(#INSERT CHESS OPENING HERE)"**
    private func createOpeningView(title: String) -> UIView {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(openingsTapped(_:)), for: .touchUpInside)
        return button
    }
    
    ///** Sends user to the variationViewController**
    @objc func openingsTapped(_ sender: UIButton) {
        let variationViewController = VariationsViewController()
        variationViewController.openingTitle = sender.currentTitle
        self.navigationController?.pushViewController(variationViewController, animated: true)
        print("\(sender.titleLabel?.text ?? "") tapped")
    }
    
    ///** Sends user to the Table View of all favorite openings**
    @objc func favoritesTapped(_ sender: UIButton) {
        let favoritesViewController = FavoritesViewController()
        self.navigationController?.pushViewController(favoritesViewController, animated: true)
    }
}

