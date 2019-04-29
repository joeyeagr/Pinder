//
//  PetCardCollectionViewController.swift
//  Pinder
//
//  Created by Benjamin Poulsen PRO on 4/7/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import Firebase
import FirebaseStorage
import FirebaseFirestore

private let reuseIdentifier = "PetCardCell"

class PetCardCollectionViewController: UICollectionViewController {
    
    var db: Firestore!
    var petCard: PetCard?
    var petCards: [PetCard?] = []
    var petImage: UIImage?
    var currentPetImageString: String?
    var index: Int = 0
    var petCardArray: [PetCard?] = []
    static let sharedController = PetCardCollectionViewController()
    
    @IBOutlet var petCardCollectionView: UICollectionView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        petCards = PetCardController.sharedController.fetchPetCards()
        
        self.collectionView!.register(PetCardCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    
    func getAllPetCards(completion: (([PetCard?]) -> Void)? = nil) {
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
    
    
    func requestAllPetCardsImages() {
        getAllPetCards { (petCards) in
            
            DispatchQueue.main.async {
                self.petCardArray = petCards
            }
        }
    }
    
    
    func updatePetCardImage() {
        let petCard = petCards[index]
        let imageString = petCard?.petImage1
        Storage.storage().reference(withPath: imageString!).getData(maxSize: (1024 * 1024), completion: { (data, error) in
            guard let data = data else {
                NSLog("No data. \(error)")
                return
            }
            let image = UIImage(data: data)
            self.petImage = image
        })
    }
    
    
    func setInsets () {
        let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
        
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return petCards.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PetCardCell {
            
            let petCard = petCards[indexPath.row]
            cell.updateUI(petCard: petCard)
            
            return cell
        }
        return UICollectionViewCell()
        
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
