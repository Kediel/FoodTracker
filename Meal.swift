//
//  Meal.swift
//  FoodTracker
//
//  Created by Kediel on 2/2/18.
//  Copyright © 2018 riOS. All rights reserved.
//

import UIKit

class Meal {
    
    // Mark: Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    // Mark: Initialization
    
    init?(name: String, photo: UIImage?, rating: Int){
        
        // The name must not be empty
        guard !name.isEmpty else {
            
            return nil
        }
        
        // The rating must be between - and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
}
