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
    var petCard: PetCard = PetCard()
    var currentPetCard: PetCard?
    var petCards = PetCardController.sharedController.fetchPetCards
    
    @IBOutlet weak var petNameTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // firebase is for dictionary string: any
        // firebase storage is for storing the URL string
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
       
        let db = Firestore.firestore()
        
        if let petCards = petCards.first {
            self.currentPetCard = petCards
            
        }
       

//        requestAllPetCardsFromFirestore { currentPetCard in
//            if let currentPetCard = currentPetCard {
//                self.currentPetCard = currentPetCard
//                print(currentPetCard.petName)
//                PetCardController.sharedController.saveToPersistentStorage(petCard: currentPetCard)
//            }
//        }
       
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
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        return PetCardController.sharedController.fetchPetCards.count    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if let currentPetCard =  currentPetCard, let image = currentPetCard.petImage1  {
            
            let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.image = UIImage(named: image)
            backgroundImage.contentMode = UIView.ContentMode.scaleToFill
            self.view.insertSubview(backgroundImage, at: 0)
            cell.backgroundView = backgroundImage
            
        }
        
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
