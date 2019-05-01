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
    
    
    var petCardsArray: [String] = []
    var petCardData: [PetCard] = []
    var index: Int = 0
    var petCards = PetCardController.sharedController.fetchPetCards()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        
        setUpImageView()
        getPetCards()
        updateLabels()
        
        DispatchQueue.main.async {
            self.getImages(imageString: self.petCardsArray[self.index])
            self.index += 1
        }
    }
    
    
    @IBAction func previousButtonTapped(_ sender: Any) {
        if index >= petCards.count {
            index = 0
            getImages(imageString: petCardsArray[index])
            updateLabels()
        }
        getImages(imageString: petCardsArray[index])
        updateLabels()
        index += 1
    }
    
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if index >= petCards.count {
            index = 0
            getImages(imageString: petCardsArray[index])
            updateLabels()
        }
        getImages(imageString: petCardsArray[index])
        updateLabels()
        index += 1
    }
    
    
    func getPetCards() {
        for petCard in petCards {
            guard let imageString = petCard.petImage1 else {return}
            
            petCardsArray.append(imageString)
            petCardData.append(petCard)
        }
    }
    
    var pets: [Pet] = []
    var petsImageString: [String] = []
    
    func cycleThroughPets() {
        for pet in pets {
            let imageString = pet.petImage1
            
            petsImageString.append(imageString)
            pets.append(pet)
        }
    }
    
    
    func getImages(imageString: String) {
        Storage.storage().reference(withPath: imageString).getData(maxSize: (1024 * 1024), completion:  { (data, err) in
            guard let data = data else {return}
            guard let image = UIImage(data: data) else {return}
            self.petImageView.image = image
        })
    }
    
    
    
    func updateLabels() {
        petNameLabel.text = petCardData[index].petName
        petAgeLabel.text = String(petCardData[index].petAge)
        petBioTextView.text = petCardData[index].petBio
        petBreedLabel.text = petCardData[index].petBreed
        datePostedLabel.text = petCardData[index].date
        contactNameLabel.text = petCardData[index].humanName
        contactEmailLabel.text = petCardData[index].humanEmail
        contactPhoneLabel.text = petCardData[index].humanPhoneNumber
        if petCardData[index].isMale == true {
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
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
}
