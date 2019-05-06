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


class HomeViewController: UIViewController {
    
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
    
    var db: Firestore!
    var divisor: CGFloat!
    var index: Int = 0
    var petCards: [PetCard] = []
    var totalPetCount: Int = 0
    
    func setCornerAndShadow() {
        petPicture.clipsToBounds = true
        
        card.layer.shadowColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        card.layer.shadowOffset = CGSize(width: 2, height: 3)
        card.layer.shadowRadius = 1.7
        card.layer.shadowOpacity = 1.0
    }
    
    
    func getArrayOfPets(completion: (([PetCard]) -> Void)? = nil) {
        let db = Firestore.firestore()
        db.collection("PetId").getDocuments { (querySnapshot, error) in
            var petCards: [PetCard] = []
            if let error = error {
                print(error)
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
    
    func setNextCardIndex() {
        index = index + 1
        
        if self.index >= totalPetCount {
            index = 0
            print("Go back to the beginning")
        }
        
        print(index)
    }
    
    func downloadPetArraysImages() {
        getArrayOfPets() { (petCards) in
            DispatchQueue.main.async {
                self.petCards = petCards
                self.totalPetCount = petCards.count
                self.updateImageviewAndLabels()
            }
        }
    }
    
    func updateImageviewAndLabels() {
        
        let pet = petCards[index]
        let imageString = pet.petImage1!
        let petName = pet.petName
        let petAge = pet.petAge
        self.petNameLabel.text = petName
        self.petAgeLabel.text = String(petAge)
        Storage.storage().reference(withPath: imageString).getData(maxSize: (1024 * 1024)) { (data, error) in
            guard let data = data else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.petPicture.image = image
                self.moveCardToMiddle()
            }
        }
    }
    
    func moveCardToMiddle() {
        self.card.center = self.view.center
        self.smileyImageView.alpha = 0
        
        UIView.animate(withDuration: 0.2) {
            self.card.alpha = 1
            self.card.transform = .identity
        }
    }
    
    func resetCard(cardDismissed: Bool = false) {
        if cardDismissed {
            self.setNextCardIndex()
            self.updateImageviewAndLabels()
        }

    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCornerAndShadow()
        petPicture.layer.cornerRadius = 25
        card.layer.cornerRadius = 25
        divisor = (self.view.frame.width / 2) / 0.61
        downloadPetArraysImages()
    }
    
    
    @IBAction func unwindToMain(_ sender: UIStoryboardSegue) {}
}



