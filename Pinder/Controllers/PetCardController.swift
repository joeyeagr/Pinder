//
//  PetCardController.swift
//  Pinder
//
//  Created by Benjamin Poulsen PRO on 4/7/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import Foundation
import CoreData

class PetCardController {
    
    static let sharedController = PetCardController()
    
    var performNewPetFetchRequest: [PetCard] {
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
    
}
