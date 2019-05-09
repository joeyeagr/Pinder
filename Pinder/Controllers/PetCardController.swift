//
//  PetCardController.swift
//  Pinder
//
//  Created by Benjamin Poulsen PRO on 4/7/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import Foundation
import CoreData
import Firebase
import FirebaseStorage
import FirebaseFirestore


class PetCardController {
    
    static let sharedController = PetCardController()
    
    
    func fetchPetCards() -> [PetCard] {
        let request: NSFetchRequest<PetCard> = PetCard.fetchRequest()
        
        do {
            return try Stack.context.fetch(request)
        } catch {
            return []
        }
    }
    
    
    func saveToPersistentStorage(petCard: PetCard) {
        do {
            try Stack.context.save()
        } catch {
            print("Save to persistent storage failed")
        }
    }
    
    
    func deletePetCardFromStack(petCardToDelete: PetCard) {
        Stack.context.delete(petCardToDelete)
        saveToPersistentStorage(petCard: petCardToDelete)
    }
                
    
    func requestAllPetCardsFromFirestore(completion: (([PetCard?]) -> Void)? = nil) {
        let db = Firestore.firestore()
        
        db.collection("PetId").getDocuments { (querySnapshot, err) in
            var petCards: [PetCard] = []
            if let err = err {
                print(err)
            } else {
                for document in querySnapshot!.documents {
                    let docData = document.data()
                    if let petCard = PetCard(dictionary: docData) {
                        petCards.append(petCard)
                    }
                }
                if let completion = completion {
                    completion(petCards)
                }
            }
        }
    }
    
    
    func requestMatchingPetIdFromFirestore(petId: String, completion: ((PetCard?) -> Void)? = nil) {
        let db = Firestore.firestore()
        
        db.collection("PetId").whereField("petId", isEqualTo: petId).getDocuments { (querySnapShot, err) in
            if let err = err {
                print(err)
            } else {
                for document in querySnapShot!.documents {
                    let docData = document.data()
                    
                    
                    if let petCard = PetCard(dictionary: docData), let completion = completion {
                        completion(petCard)
                    }
                }
            }
        }
    }
    
    
    func requestOnePetCardFromFirestore(completion: ((PetCard?) -> Void)? = nil) {
        let db = Firestore.firestore()
        
        db.collection("PetId").getDocuments { (querySnapshot, err) in
            if let err = err {
                print(err)
            } else {
                for document in querySnapshot!.documents {
                    let docData = document.data()
                    
                    if let currentPetCard = PetCard(dictionary: docData), let completion = completion {
                        completion(currentPetCard)
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
}
