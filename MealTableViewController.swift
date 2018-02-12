//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Kediel on 2/3/18.
//  Copyright © 2018 riOS. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var meals = [Meal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load the sample data.
        loadSampleMeals()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return meals.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let meal = meals[indexPath.row]
        
        

        // Configure the cell
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating

        return cell
    }
    


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            // Removes the Meal object to be deleted from the meals array.
            meals.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

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

    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        
        case "AddItem":
        os_log("Adding a new meal.", log: OSLog.default, type: .debug)
        
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? MealViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
        
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            
        }
    }
    
    // MARK: Actions
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        /*
         This code uses the optional type cast operator (as?) to try to downcast the segue’s source view controller to a MealViewController instance. You need to downcast because sender.sourceViewController is of type UIViewController, but you need to work with a MealViewController.
 
         The operator returns an optional value, which will be nil if the downcast wasn’t possible. If the downcast succeeds, the code assigns the MealViewController instance to the local constant sourceViewController, and checks to see if the meal property on sourceViewController is nil. If the meal property is non-nil, the code assigns the value of that property to the local constant meal and executes the if statement.
 
         If either the downcast fails or the meal property on sourceViewController is nil, the condition evaluates to false and the if statement doesn’t get executed.
         */
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            
            // Checks whether a row in the table view is selected.
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                // Updates the meal array.
                meals[selectedIndexPath.row] = meal
                // Reloads the appropriate row in the table view.
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
            
            // Add a new meal.
            let newIndexPath = IndexPath(row: meals.count, section: 0)
            
            // Adds a new meal to the existing list of meals in the data model.
            meals.append(meal)
            
            // The .automatic animation option uses the best animation based on the table’s current state, and the insertion point’s location.
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    // MARK: Private Methods
    
    private func loadSampleMeals() {
        
        let photo1 = UIImage(named: "beer")
        let photo2 = UIImage(named: "burger")
        let photo3 = UIImage(named: "dish")
        
        guard let beer = Meal(name: "Beer and snacks", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1 (beer)")
        }
        
        guard let burger = Meal(name: "Spicy Avacado Burger", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2(burger)")
        }
        
        guard let dish = Meal(name: "Pasta dish", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal3(dish)")
        }
        
        meals += [beer, burger, dish]
    }
}
