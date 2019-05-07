//
//  PetDetailViewController.swift
//  Pinder
//
//  Created by Benjamin Poulsen PRO on 4/28/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import Firebase
import FirebaseStorage
import FirebaseFirestore

class PetDetailViewController: UIViewController {
    
    
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var petAgeLabel: UILabel!
    @IBOutlet weak var petBreedLabel: UILabel!
    @IBOutlet weak var petGenderLabel: UILabel!
    @IBOutlet weak var datePostedLabel: UILabel!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactEmailLabel: UILabel!
    @IBOutlet weak var contactPhoneLabel: UILabel!
    @IBOutlet weak var petBioTextView: UITextView!
    
    static let sharedController = PetDetailViewController()
    var petCardsImageStringArray: [String] = []
    var petCardArray: [PetCard] = []
    var index: Int = 0
    var petCards = PetCardController.sharedController.fetchPetCards()
    var totalPetCount: Int = 0
    var passedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.navigationController?.navigationBar.isHidden = false
        
       
        
//        if let passedIndexPath = passedIndexPath?.first {
//            print(passedIndexPath)
//            let petCards2 = petCards[passedIndexPath]
//            if let imageString = petCards2.petImage1 {
//                getImages(imageString: imageString)
//
//            }
//        }
        
        setUpImageView()
//        getPetCards()
//        updateLabels()
        
        
        DispatchQueue.main.async {
            self.updateImages()
//            self.index += 1
        }
    }
    
    func updateImages() {
    guard let petImageString = petCards[index].petImage1 else {return}
    
    getImages(imageString: petImageString)
    updateLabels()
    }
    
    
    @IBAction func previousButtonTapped(_ sender: Any) {
        index -= 1
        
        if index < 0 {
            index = petCards.count - 1
        }
        
        updateImages()
        
        print(index)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        index += 1
        
        if index >= petCards.count {
            index = 0
        }
        
        updateImages()

        print(index)
    }
    
    
    func getPetCards() {
        for petCard in petCards {
            guard let imageString = petCard.petImage1 else {return}
            petCardsImageStringArray.append(imageString)
            petCardArray.append(petCard)
        }
    }
    
    var pets: [Pet] = []
    var petsImageString: [String] = []
    
    func cycleThroughPets() {
        for pet in pets {
            let imageString = pet.petImage1
            let petId = pet.petId
            let petCardDict = ["PetId": petId]
            
            let petCard = PetCard(dictionary: petCardDict)
            if let petCard = petCard {
                print(petCard)
            }
            
            petsImageString.append(imageString)
            pets.append(pet)
        }
        let petTest = PetCardController.sharedController.fetchPetCards()
        print(petTest.count)
        print(petTest)
    }
    
    
    func getImages(imageString: String) {
        Storage.storage().reference(withPath: imageString).getData(maxSize: (1024 * 1024), completion:  { (data, err) in
            guard let data = data else {return}
            guard let image = UIImage(data: data) else {return}
            self.petImageView.image = image
        })
    }
    
    
    
    func updateLabels() {
        petNameLabel.text = petCards[index].petName
        petAgeLabel.text = String(petCards[index].petAge)
        petBioTextView.text = petCards[index].petBio
        petBreedLabel.text = petCards[index].petBreed
        datePostedLabel.text = petCards[index].date
        contactNameLabel.text = petCards[index].humanName
        contactEmailLabel.text = petCards[index].humanEmail
        contactPhoneLabel.text = petCards[index].humanPhoneNumber
        if petCards[index].isMale == true {
            petGenderLabel.text = "Female"
        } else {
            petGenderLabel.text = "Male"
        }
    }
    
    
    func setUpImageView() {
        petImageView.layer.cornerRadius = 25
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Gradient")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
        petImageView.layer.borderColor = UIColor.black.cgColor
        petImageView.layer.borderWidth = 2.0
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        PetCardController.sharedController.deletePetCardFromStack(petCardToDelete: petCards[index])
        if PetCardController.sharedController.fetchPetCards().count == 0 {
            noSavedPetsAlert()
        } else {
            index += 1
            updateImages()
        }
    }
    
    func noSavedPetsAlert() {
        let alert = UIAlertController(title: "You Have No More Pets Saved", message: "Swipe Right to Add Pets to Your Collection", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Swipe!", style: .default, handler: { action in
            self.dismiss(animated: true, completion: {
                self.navigationController?.navigationBar.isHidden = true

            })
        }))
        present(alert, animated: true)
        
    }
    
    
    
    override func encodeRestorableState(with coder: NSCoder) {
        //1
        if let petCardId = petCards[index].petId {
            
           coder.encode(petCardId, forKey: "petId")
            

        }
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        if let petId = coder.decodeData() {
            
        }
        
        super.decodeRestorableState(with: coder)
    }
}
