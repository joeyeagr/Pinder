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
    var petAge: String
    var isMale: Bool
    var petBio: String
    var date: String
    var petImage: String
    var humanContact: Array<String>
    var humanId: String
    
    var petDictionary: [String: Any] {
        return [
            "petId": petId,
            "petName": petName,
            "petBreed": petBreed,
            "petAge": petAge,
            "isMale": isMale,
            "petBio": petBio,
            "date": date,
            "petImage": petImage,
            "humanContact": humanContact,
            "humanId": humanId
        ]
    }
    
}

extension Pet {
    init?(petDictionary: [String : Any]) {
        guard let petId = petDictionary["petId"] as? String,
            let petName = petDictionary["petName"] as? String,
            let petBreed = petDictionary["petBreed"] as? String,
            let petAge = petDictionary["petAge"] as? String,
            let isMale = petDictionary["isMale"] as? Bool,
            let petBio = petDictionary["petBio"] as? String,
            let date = petDictionary["date"] as? String,
            let petImage = petDictionary["petImage"] as? String,
            let humanContact = petDictionary["humanContact"] as? Array<String>,
            let humanId = petDictionary["humanId"] as? String else {return nil}
        self.init(petId: petId, petName: petName, petBreed: petBreed, petAge: petAge, isMale: isMale, petBio: petBio, date: date, petImage: petImage, humanContact: humanContact, humanId: humanId)
    }
}
