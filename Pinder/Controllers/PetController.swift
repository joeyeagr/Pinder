//
//  PetController.swift
//  Pinder
//
//  Created by Benjamin Poulsen PRO on 5/8/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import Foundation
import Foundation
import CoreData
import Firebase
import FirebaseStorage
import FirebaseFirestore



class PetController {
    
    static let sharedController = PetController()
    
    var pets: [Pet] = []
    var index: Int = 0
    
    func pullDownAllPets(completion: (([Pet]) -> Void)? = nil) {
        let db = Firestore.firestore()
        db.collection("PetId").getDocuments { (querySnapshot, err) in
            var pets: [Pet] = []
            if let err = err {
                print(err)
            } else {
                for document in querySnapshot!.documents {
                    let docData = document.data()
                    if let pet = Pet(petDictionary: docData) {
                        pets.append(pet)
                    }
                }
                if let completion = completion {
                    completion(pets)
                }
            }
        }
    }
    
    
    func downLoadAllPets() {
        pullDownAllPets { (pets) in
            DispatchQueue.main.async {
                self.pets = pets
            }
        }
    }
    
    
    func updatePetsImage() {
        let pet = pets[index]
        let imageString = pet.petImage1
        Storage.storage().reference(withPath: imageString).getData(maxSize: (1024 * 1024), completion: { (data, error) in
            guard let data = data else {
                NSLog("No data. \(error)")
                return
            }
            let image = UIImage(data: data)
            //            self.petsImage = image
        })
    }
    
    
    func savePetAsPetCard(petCard: Pet) {
        _ = PetCard(dictionary: petCard.petDictionary)
        do {
            try Stack.context.save()
        } catch {
            print("Save to persistent storage failed")
        }
    }
    
    
    
    
    
    
    
}
