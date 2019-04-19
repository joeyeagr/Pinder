//
//  PetCard.swift
//  Pinder
//
//  Created by Benjamin Poulsen PRO on 4/7/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import Foundation
import CoreData

extension PetCard {
    convenience init?(dictionary: Dictionary<String, Any>, context: NSManagedObjectContext = Stack.context) {
        
        guard
            let humanContact = dictionary["humanContact"] as? [String],
            let date = dictionary["date"] as? String,
            let petId = dictionary["petId"] as? String,
            let petBreed = dictionary["petBreed"] as? String,
            let petAge = dictionary["petAge"] as? Int16,
            let petBio = dictionary["petBio"] as? String,
            let petImage1 = dictionary["petImage1"] as? String,
            let petImage2 = dictionary["petImage2"] as? String,
            let petGender = dictionary["petGender"] as? Bool,
            let petName = dictionary["petName"] as? String
            else {
                return nil
            }
        
        self.init(context: context)
        
        self.date = date
        self.humanId = humanContact[2]
        self.humanName = humanContact[0]
        self.humanEmail = humanContact[3]
        self.humanPhoneNumber = humanContact[1]
        self.petId = petId
        self.petName = petName
        self.petBreed = petBreed
        self.petAge = petAge
        self.petGender = petGender
        self.petBio = petBio
        self.petImage1 = petImage1
        self.petImage2 = petImage2
    }
}
