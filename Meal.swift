//
//  Meal.swift
//  FoodTracker
//
//  Created by Kediel on 2/2/18.
//  Copyright © 2018 riOS. All rights reserved.
//

import UIKit
import os.log

class Meal: NSObject, NSCoding {
    
    // Mark: Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    // Mark: Types
    
    struct PropertyKey {
        
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
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
    
    // Mark: NSCoding
    // The NSCoder class defines a number of encode(_:forKey:) methods, each one taking a different type for the first argument. Each method encodes data of the given type. The first two lines pass a String argument, while the third line passes an Int. These lines encode the value of each property on the Meal class and store them with their corresponding key.
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    // The required modifier means this initializer must be implemented on every subclass, if the subclass defines its own initializers.
    
    // The convenience modifier means that this is a secondary initializer, and that it must call a designated initializer from the same class.
    
    // The question mark (?) means that this is a failable initializer that might return nil.
    required convenience init?(coder aDecoder: NSCoder) {
        
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photo) as? UIImage
        
        let rating = aDecoder.decodeIntegerForKey(PropertyKey.rating)
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, rating: rating)
    }
}
