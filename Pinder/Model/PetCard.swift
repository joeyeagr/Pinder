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
            let petAge = dictionary["petAge"] as? String,
            let petBio = dictionary["petBio"] as? String,
            let petImage = dictionary["petImage"] as? String,
            let humandId = dictionary["humanId"] as? String,
            let isMale = dictionary["isMale"] as? Bool,
            let petName = dictionary["petName"] as? String
            
            else {
                return nil
        }
        
        self.init(context: context)
        
        self.date = date
        self.humanId = humandId
        self.humanName = humanContact[0]
        self.humanEmail = humanContact[1]
        self.humanPhoneNumber = humanContact[2]
        self.petId = petId
        self.petName = petName
        self.petBreed = petBreed
        self.petAge = petAge
        self.isMale = isMale
        self.petBio = petBio
        self.petImage = petImage
    }
}
