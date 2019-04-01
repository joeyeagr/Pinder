//
//  Pet.swift
//  Pinder
//
//  Created by Tyler Donohue on 3/29/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import Foundation
// make sure to add a date for when the post was created.
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import Firebase

struct Pet {
    var petId: String
    var petName: String
    var petBreed: String
    var petAge: Int
    var petGender: Array = ["Male", "Female"]
    var petBio: String
    var petImage1: UIImage
    var petImage2: UIImage
    
    var dictionary: [String: Any] {
        return [
            "id": petId,
            "petName": petName,
            "petBreed": petBreed,
            "petAge": petAge,
            "petGender": petGender,
            "petBio": petBio,
            "petImage1": petImage1,
            "petImage2": petImage2
            
            
        ]
    }
    
}
