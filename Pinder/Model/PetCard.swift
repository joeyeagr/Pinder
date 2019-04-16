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
            //let petId = dictionary["petId"] as? String,
            let petName = dictionary["petName"] as? String,
//            let petBreed = dictionary["petBreed"] as? String,
//            let petAge = dictionary["petAge"] as? String,
//            let petBio = dictionary["petBio"] as? String,
//            let petImage1 = dictionary["petImage1"] as? String,
//            let petImage2 = dictionary["petImage2"] as? String,
//            let petGender = dictionary["petGender"] as? String,
//            let name = dictionary["name"] as? String,
//            let email = dictionary["email"] as? String,
            //let phoneNumber = dictionary["phoneNumber"] as? String,
            let humanId = dictionary["humanId"] as? String else {return nil}
        //contactInfo: [name, phone, email, id]
        
        self.init(context: context)
        
       // self.petId = petId
        self.petName = petName
//        self.petBreed = petBreed
//        self.petAge = petAge
//        self.petGender = petGender
//        self.petBio = petBio
//        self.petImage1 = petImage1
//        self.petImage2 = petImage2
//        self.name = name
//        self.email = email
//        //self.phoneNumber = phoneNumber
        self.humanId = humanId
        
    }
}
