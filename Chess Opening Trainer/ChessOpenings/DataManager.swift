//
//  DataManager.swift
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


class DataManager {
    static let shared  = DataManager()
    private let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    func preLoadData() {
        let context = persistentContainer.viewContext

        // Delete existing Move entities
        let moveFetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Move")
        let moveDeleteRequest = NSBatchDeleteRequest(fetchRequest: moveFetchRequest)

        do {
            try context.execute(moveDeleteRequest)
        } catch {
            // Handle the error
            print("Error deleting existing Move entities: \(error.localizedDescription)")
        }

        // Delete existing Variation entities
        let variationFetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Variation")
        let variationDeleteRequest = NSBatchDeleteRequest(fetchRequest: variationFetchRequest)

        do {
            try context.execute(variationDeleteRequest)
        } catch {
            // Handle the error
            print("Error deleting existing Variation entities: \(error.localizedDescription)")
        }

        // Delete existing Opening entities
        let openingFetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Opening")
        let openingDeleteRequest = NSBatchDeleteRequest(fetchRequest: openingFetchRequest)

        do {
            try context.execute(openingDeleteRequest)
        } catch {
            // Handle the error
            print("Error deleting existing Opening entities: \(error.localizedDescription)")
        }

        // Proceed with the existing code to check for data and load the initial data
        let openingCountRequest: NSFetchRequest<Opening> = Opening.fetchRequest()
        let count = try? context.count(for: openingCountRequest)
        if count == 0 {
            print("Loading initial data...")
            loadInitialData(context: context)
        } else {
            print("Data already exists. Count: \(count ?? 0)")
        }
    }
    
    func loadInitialData(context: NSManagedObjectContext) {
        let data: [String: [String: [String]]] = [
            "Ruy Lopez": [
                "Berlin Defense": ["RLE2E4", "RLE7E5", "RLG1F3", "RLB8C6", "RLF1B5"]
            ],
            "Petrov Defense": [
                "The Steinitz Variation": ["PDE2E4", "PDE7E5", "PDG1F3", "PDG8F6", "PDD2D4"]
            ],
            "Sicilian Defense": [
                "Najdorf Variation": ["SDE2E4", "SDC7C5", "SDG1F3", "SDD7D6", "SDD2D4"]
            ],
            "Caro-Kann": [
                "The Panov-Botvinnik Attack": ["CKE2E4", "CKC7C6", "CKD2D4", "CKD7D5", "CKE4D5", "CKC6D5"]
            ],
            "Queen's Gambit Declined": [
                "Lasker Defence": ["QGDD2D4", "QGDD7D5", "QGDC2C4", "QGDE7E6", "QGDB1C3"]
            ],
            "Nimzo-Indian Defense": [
                "The Samisch Variation": ["NIDD2D4", "NIDG8F6", "NIDC2C4", "NIDE7E6", "NIDB1C3"]
            ],
            "The Catalan Opening": [
                "The Open Catalan": ["TCOD2D4", "TCOG8F6", "TCOC2C4", "TCOE7E6", "TCOG2G3"]
            ],
            "The Slav Defense": [
                "The Semi-Slav Defense": ["TSDD2D4", "TSDD7D5", "TSDC2C4", "TSDC7C6", "TSDG1F3"]
            ],
            "Reti Opening": [
                "Reti Gambit": ["ROG1F3", "ROD7D5", "ROC2C4", "ROD5D4", "ROE2E3"]
            ],
            "English Opening": [
                "Reversed Sicilian": ["EOC2C4", "EOE7E5", "EOB1C3", "EOG8F6", "EOG1F3"]
            ]
        ]
        
        for (openingName, variations) in data {
            // Create the Opening entity
            let opening = Opening(context: context)
            opening.name = openingName
            
            for (variationName, moveKeys) in variations {
                // Create the Variation entity
                let variation = Variation(context: context)
                variation.name = variationName
                variation.opening = opening
                
                for (index, moveKey) in moveKeys.enumerated() {
                    // Create the Move entity
                    let move = Move(context: context)
                    move.notation = moveKey
                    move.variation = variation
                    move.moveOrder = Int16(index)
                    print("Move key set: \(move.notation ?? "nil")")
                }
            }
            
            do {
                try context.save()
            } catch {
                print("Error saving: \(error)")
            }
        }
    }
}


