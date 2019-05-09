//
//  ViewController.swift
//  Pinder
//
//  Created by Joe Eagar on 3/22/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.


import UIKit
import Foundation
import CoreData
import Firebase
import FirebaseStorage
import FirebaseFirestore

class ViewController: UIViewController {
    
    @IBOutlet weak var petPicture: UIImageView!
    @IBAction func profileButton(_ sender: Any) {
        
    }
    @IBAction func likedPetsButton(_ sender: Any) {
    }
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var petAgeLabel: UILabel!
    @IBOutlet weak var smileyImageView: UIImageView!
    
    @IBOutlet weak var card: UIView!
    
    @IBAction func resetButton(_ sender: UIButton) {
        resetCard()
    }
    
    var petCardArray: [PetCard?] = []
    
    var petCard: PetCard?
    var db: Firestore!
    var divisor: CGFloat!
    var index: Int = 0
//    let sharedController = ViewController()
    
    
    func setCornerAndShadow() {
        petPicture.clipsToBounds = true
        
        card.layer.shadowColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        card.layer.shadowOffset = CGSize(width: 2, height: 3)
        card.layer.shadowRadius = 1.7
        card.layer.shadowOpacity = 1.0
    }

    func requestAllPetCardsFromFirestore(completion: ((PetCard?) -> Void)? = nil) {
        let db = Firestore.firestore()
        
        db.collection("PetId").getDocuments { (querySnapshot, err) in
            DispatchQueue.main.async {
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
//                if let firstPet = petCards.first {
//                    self.updatePetCardImage()
//                }
            }
        }
    }
//    func updateNewCard() {
//        requestAllPetCardsFromFirestore { petCard in
//            if let petCard = petCard {
//                self.petCard = petCard
//                print(petCard)
//                self.petNameLabel.text = petCard.petName
//                self.petAgeLabel.text = String(petCard.petAge)
//
//                let imageName = petCard.petImage1
//
//                Storage.storage().reference(withPath: imageName!).getData(maxSize: (1024 * 1024), completion: { (data, error) in
//                    guard let data = data else {
//                        NSLog("No data. \(error)")
//                        return
//                    }
//                    let image = UIImage(data: data)
//                    self.petPicture.image = image
//                })
//            }
//        }
//    }

    func resetCard() {
        UIView.animate(withDuration: 0.2, animations: {
            self.card.center = self.view.center
            self.smileyImageView.alpha = 0
            self.card.alpha = 1
            self.card.transform = .identity
        })
        
    }
    
    func updatePetCardImage() {
        let petCard = petCardArray[index]
        let imageString = petCard?.petImage
        Storage.storage().reference(withPath: imageString!).getData(maxSize: (1024 * 1024), completion: { (data, error) in
            guard let data = data else {
                NSLog("No data, \(error)")
                return
            }
            let image = UIImage(data: data)
            self.petPicture.image = image
            self.resetCard()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCornerAndShadow()
        petPicture.layer.cornerRadius = 25
        card.layer.cornerRadius = 25
        divisor = (view.frame.width / 2) / 0.61
   
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        index += 1
//        getAllPetCards()
//        updatePetCardImage()
        
    }
    
    
//    @IBAction func unwindToHome(_ sender: UIStoryboardSegue) {
//
//    }
    @IBAction func unwindToMain(_ sender: UIStoryboardSegue) {}
}


