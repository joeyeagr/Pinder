//
//  PetCardCollectionViewController.swift
//  Pinder
//
//  Created by Benjamin Poulsen PRO on 4/7/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseStorage
import FirebaseFirestore

private let reuseIdentifier = "petCardCell"

class PetCardCollectionViewController: UICollectionViewController {

    var db: Firestore!
    var responseDictionary: [String: Any]?
    var responseDoucment: [String: Any]?
    var petCard: PetCard = PetCard()

    override func viewDidLoad() {
        super.viewDidLoad()
        // firebase is for dictionary string: any
        // firebase storage is for storing the URL string
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
       
        let db = Firestore.firestore()
        
        //requestPetNames()
        //requestMatchingPetId()
        //requestAllPetIdDocuments()
        requestPetData() { petCard in
            if let petCard = petCard {
                self.petCard = petCard
                PetCardController.sharedController.saveToPersistentStorage(petCard: petCard)
                print("let \(petCard)")
                print("var \(petCard)")
            }
            
        }
       
        PetCardController.sharedController.petCards
    }
    
    
    
    func requestPetData(completion: ((PetCard?) -> Void)? = nil) {
        let db = Firestore.firestore()
        
        db.collection("pets").whereField("humanId", isEqualTo: "12").getDocuments { (querySnapShot, err) in
            if let err = err {
                print(err)
            } else {
                for document in querySnapShot!.documents {
                    print(document.data())
                    
                    let petCard = PetCard(dictionary: document.data())
                    if let petCard = petCard {
                        print(petCard)
                    }
                    if let completion = completion {
                        completion(petCard)
                    }
                }
            }
        }
    }
    
    func requestMatchingPetId() {
        let db = Firestore.firestore()
        
        db.collection("petId").start(at: [1]).whereField("petId", isEqualTo: "12").order(by: "petId").getDocuments { (querySnapShot, err) in
            if let err = err {
                print(err)
            } else {
                for document in querySnapShot!.documents {
                    print(document.data())
                }
            }
        }
    }
    //maybe create doc func and assign pet id to document id
    func requestAllPetIdDocuments() {
        let db = Firestore.firestore()

        db.collection("petId").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("could not get documents \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("here is the document data \(document.documentID)\(document.data())")
                    let documentData = document.data()
                    print(documentData)
                    self.responseDictionary = documentData
                    
                    if  let petId = documentData["petId"] as? String{
                        let petName = documentData["petName"] as? String
                        print(petId, petName)
                    }
                    
                   let docVals = documentData.values
                    let response = documentData
                    
                    if let petName = response["petName"] as? [String: Any] {
                        let petCard = PetCard(dictionary: petName, context: Stack.context)
                        print(petCard)
                        print(petCard?.name)
                        self.responseDictionary = petName
                        if let petName = petCard?.name {
                            print(petName)
                        }
                    }
                    
                    
                    
                    
                    
                    
                }
            }
        }
    }
    
    
    
    struct PetCardTest {
        var petId: String
        var petName: String
        
        var dictionary: [String: Any] {
            return [
                "petId": petId,
                "petName": petName
            ]
        }
        
        
    }
    
    
    func setInsets () {
       let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
        
    }
    
    func addPetCard() {
        guard let entity = NSEntityDescription.entity(forEntityName: "PetCard", in: Stack.context) else {
            fatalError("could make pet")
        }
//
//        let petCard = NSManagedObject(entity: entity, insertInto: Stack.context)
//        petCard.setValue(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
//        for x in 1...25 {
//            let petCard = NSManagedObject(entity: entity, insertInto: Stack.context)
//            petCard.setValue("Pet id #\(x)", forKey: "petId")
//        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return PetCardController.sharedController.petCards.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
