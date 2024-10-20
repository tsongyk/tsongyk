//
//  FavoritesViewController.swift
//  ChessOpenings
//
//  Created by Justin Rogers on 4/19/24.
//
/*
 Submission Date: 26 April 2024
 Justin Rogers, rogerju@iu.edu
 Tommy Song, songtom@iu.edu
 
 iOS App Name: ChessOpenings
 */

import UIKit
import CoreData

class FavoritesViewController: UITableViewController {
    var favoriteVariations: [Variation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FavoritesCell")
        reloadFavorites()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFavorites), name: NSNotification.Name("FavoritesUpdated"), object: nil)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func fetchFavoriteVariations() -> [Variation] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Variation> = Variation.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavorite == YES")
        
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print("Could not fetch favorites: \(error), \(error.userInfo)")
            return []
        }
    }
    
    @objc func reloadFavorites() {
        favoriteVariations = fetchFavoriteVariations()
        tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favoriteVariations.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath)
        let favorite = favoriteVariations[indexPath.row]
        cell.textLabel?.text = "\(favorite.opening?.name ?? "Unknown Opening") - \(favorite.name ?? "Unknown Variation")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let selectedVariation = favoriteVariations[indexPath.row]
        let demonstrationViewController = DemonstrationViewController()
        demonstrationViewController.variationName = selectedVariation.name
        navigationController?.pushViewController(demonstrationViewController, animated: true)
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
