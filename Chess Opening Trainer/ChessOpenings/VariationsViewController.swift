//
//  VariationsViewController.swift
//  ChessOpenings
//
//  Created by Justin Rogers on 4/10/24.
//
/*
 Submission Date: 26 April 2024
 Justin Rogers, rogerju@iu.edu
 Tommy Song, songtom@iu.edu
 
 iOS App Name: ChessOpenings
 */

import UIKit
import CoreData

class VariationsViewController: UIViewController {

    var openingTitle: String?
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = openingTitle
        view.backgroundColor = .white
        
        setupTitleLabel()
        
        setupScrollViewAndStackView()
        
        if let title = openingTitle {
            let variations = fetchVariations(forOpeningWithName: title)
            setupVariationButtons(variations)
        }

        // Do any additional setup after loading the view.
    }
    
    func setupTitleLabel() {
        
        let variationsTitle = UILabel()
        variationsTitle.translatesAutoresizingMaskIntoConstraints = false
        variationsTitle.text = "\(openingTitle ?? "Default Title") Variations"
        variationsTitle.textAlignment = .center
        variationsTitle.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(variationsTitle)
        
        NSLayoutConstraint.activate([
            variationsTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            variationsTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            variationsTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            variationsTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupScrollViewAndStackView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    
    func fetchVariations(forOpeningWithName name: String) -> [Variation] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Opening> = Opening.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let openings = try context.fetch(fetchRequest)
            print("Fetched openings: \(openings)")
            let variations = openings.first?.variations?.allObjects as? [Variation] ?? []
            print("Fetched variations: \(variations)")
            return variations
        } catch {
            print("error fetching variations for opening: \(name)")
            return []
        }
    }
    
    
    func setupVariationButtons(_ variations: [Variation]) {
        for variation in variations {
            if let title = variation.name {
                let button = createVariationButton(title: title)
                stackView.addArrangedSubview(button)
                button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            }
        }
    }
    
    func createVariationButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(variationButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc func variationButtonTapped(_ sender: UIButton){
        guard let variationTitle = sender.currentTitle else { return }
        print("\(variationTitle) variation tapped")
        let demonstrationViewController = DemonstrationViewController()
        demonstrationViewController.variationName = variationTitle
        self.navigationController?.pushViewController(demonstrationViewController, animated: true)
    }
                    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
