//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Kediel on 1/29/18.
//  Copyright © 2018 riOS. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by 'MealTableViewController' in
     'prepare(for:sender:)
     or constructed as part of adding a new meal.
    */
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field's user input through delegate callbacks.
        nameTextField.delegate = self
        
        // Set up views if editing an existing Meal.
        if let meal = meal {
            
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // Checks if the text field is empty.
        updateSaveButtonState()
        // Sets the title of the scene to the text in the text field.
        navigationItem.title = textField.text
        
        
    }
    
    // Mark: UIIMagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        
    }
    
    // Mark: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        // Depending on style of presentation (modal/push), this view controller needs to be dismissed in two different ways.
        // Creates a Boolean value that indicates whether the view conrtoller presented is of type UINavigationController.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        // Checks to make sure the user was adding a new meal before calling the dimiss function.
        if isPresentingInAddMealMode {
            
            dismiss(animated: true, completion: nil)
        // Called if the user is editing an existing meal. Meaning the meal detail was pushed onto a navigation stack.
        } else if let owningNavigationController = navigationController {
            
            owningNavigationController.popViewController(animated: true)
        // Executes only if the meal detail scene was not preseneted inside a modal nav controller, and if the scene was not pushed onto a nav stack.
        } else {
            
            fatalError("The MealViewController is not inside a navigation controller.")
        }
        
    }
    
    // This method lets you configure a view controller before it's presented. (Segues are what let's you navigate throught the scenes)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for:segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        // Verifies that the sender is a button and uses the identity operator(===) to check that the objects referenced by the sender and saveButton outlet are the same.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        // The nil coalescing operator (??) is used to return the value of an optional if the optional has a value, or return a default value otherwise.
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        meal = Meal(name: name, photo: photo, rating: rating)
        
    }
    
    // Mark: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // Mark: Private Methods
    private func updateSaveButtonState() {
        
        // Disable the save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

