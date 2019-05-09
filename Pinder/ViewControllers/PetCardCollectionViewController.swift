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
    
    
    static let sharedController = PetCardCollectionViewController()

    var db: Firestore!
    var petCards: [PetCard?] = []
    var index: Int = 0
    var pets: [Pet] = []
    var petsImage: UIImage?
    var passedIndex = [String]()
    
    @IBOutlet var petCardCollectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PetCardController.sharedController.fetchPetCards().count == 0 {
            getAllPetCards()
            noSavedPetsAlert()
        }
        
        petCards = PetCardController.sharedController.fetchPetCards()
        print(PetCardController.sharedController.fetchPetCards().count)
        
        setBackGroundImage()
    }
    
    
    func setBackGroundImage() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Gradient")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.collectionView.backgroundView = backgroundImage
    }
    
    
    func noSavedPetsAlert() {
        let alert = UIAlertController(title: "You Have No Pets Saved Yet", message: "Swipe Right to Add Pets to Your Collection", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Swipe!", style: .default, handler: { action in
            self.dismiss(animated: true, completion: {
                self.navigationController?.navigationBar.isHidden = true
            })
        }))
        present(alert, animated: true)
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
                        PetCardController.sharedController.saveToPersistentStorage(petCard: petCard)
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
//                self.petCardArray = petCards
            }
        }
    }
    
    
    func updatePetCardImage() {
        let petCard = petCards[index]
        let imageString = petCard?.petImage
        Storage.storage().reference(withPath: imageString!).getData(maxSize: (1024 * 1024), completion: { (data, error) in
            guard let data = data else {
                NSLog("No data. \(error)")
                return
            }
            let image = UIImage(data: data)
//            self.petImage = image
        })
    }
    
    
    func updatePetsImage() {
        let pet = pets[index]
        let imageString = pet.petImage
        Storage.storage().reference(withPath: imageString).getData(maxSize: (1024 * 1024), completion: { (data, error) in
            guard let data = data else {
                NSLog("No data. \(error)")
                return
            }
            let image = UIImage(data: data)
            self.petsImage = image
        })
    }
    
    
    func setInsets () {
        let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    }
    
    
    // MARK: UICollectionViewDataSource
    
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellTappedSegue" {
            let petDetailViewController = segue.destination as! PetDetailViewController
            guard let index = collectionView.indexPathsForSelectedItems?.first else { return }
            petDetailViewController.index = index.row
        }
    }
    
    
    
    
    //    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        <#code#>
    //    }
    
    
    // MARK: UICollectionViewDelegate
    
    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
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
