//
//  Pet.swift
//  Pinder
//
//  Created by Tyler Donohue on 3/29/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import Firebase

protocol PetIdentifiable {
    var petId: String? { get set }
}

protocol PetDocumentUserSerializable {
    init(petDictionary: [String: Any])
}

struct Pet {
    var petId: String
    var petName: String
    var petBreed: String
    var petAge: Int
    var isMale: Bool // change the name to isMale
    var petBio: String
    var date: String
    var petImage1: String
    var petImage2: String
    var humanContact: Array<String>
    
    var petDictionary: [String: Any] {
        return [
            "petId": petId,
            "petName": petName,
            "petBreed": petBreed,
            "petAge": petAge,
            "isMale": isMale,
            "petBio": petBio,
            "date": date,
            "petImage1": petImage1,
            "petImage2": petImage2,
            "humanContact": humanContact
            
        ]
    }
    
}

extension Pet {
    init?(petDictionary: [String : Any]) {
        guard let petId = petDictionary["petId"] as? String,
            let petName = petDictionary["petName"] as? String,
            let petBreed = petDictionary["petBreed"] as? String,
            let petAge = petDictionary["petAge"] as? Int,
            let isMale = petDictionary["isMale"] as? Bool,
            let petBio = petDictionary["petBio"] as? String,
            let date = petDictionary["date"] as? String,
            let petImage1 = petDictionary["petImage1"] as? String,
            let petImage2 = petDictionary["petImage2"] as? String,
            let humanContact = petDictionary["humanContact"] as? Array<String> else {return nil}
        self.init(petId: petId, petName: petName, petBreed: petBreed, petAge: petAge, isMale: isMale, petBio: petBio, date: date, petImage1: petImage1, petImage2: petImage2, humanContact: humanContact)
    }
}
