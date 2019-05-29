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
import FirebaseAuth


class HomeViewController: UIViewController {

    @IBOutlet weak var petPicture: UIImageView!
    @IBAction func profileButton(_ sender: Any) {
        
        performSegue(withIdentifier: "segueToFirebase", sender: nil)
    }
    @IBAction func likedPetsButton(_ sender: Any) {
    }
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var petAgeLabel: UILabel!
    @IBOutlet weak var smileyImageView: UIImageView!
    @IBOutlet weak var card: UIView!
    @IBAction func resetButton(_ sender: UIButton) {
        setPreviousCardIndex()
        updatePetsImageAndLabels()
    }
    
    var db: Firestore!
    var divisor: CGFloat = 200
    var index: Int = 0
    var pets: [Pet] = []
    var totalPetCount: Int = 0
    var currentAuthID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
    }
    
    func checkForId() { // issue implmenting this in, working on fixing the firebase error
        guard let id: String? = self.currentAuthID else { return }
        if id == nil {
            performSegue(withIdentifier: "TransitionToLogIn", sender: nil)
        } else {
            print("to account")
            performSegue(withIdentifier: "TransitionToAcount", sender: nil)
        }
    }
    
    func setCornerAndShadow() {
        petPicture.clipsToBounds = true
        card.layer.shadowColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        card.layer.shadowOffset = CGSize(width: 2, height: 3)
        card.layer.shadowRadius = 1.7
        card.layer.shadowOpacity = 1.0
    }

    func pullDownAllPets(completion: (([Pet]) -> Void)? = nil) {
        let db = Firestore.firestore()
        db.collection("PetId").getDocuments { (querySnapshot, err) in
            var pets: [Pet] = []
            if let err = err {
                print(err)
            } else {
                for document in querySnapshot!.documents {
                    let docData = document.data()
                    if let pet = Pet(petDictionary: docData) {
                        pets.append(pet)
                    }
                }
                if let completion = completion {
                    completion(pets)
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
    
    func setPreviousCardIndex() {
        index = index - 1
        if self.index <= 0 {
            index = 0
            print("sorry, can't refresh")
        }
        print(index)
    }
    
    func downloadAllPets() {
        pullDownAllPets { (pets) in
            DispatchQueue.main.async {
                self.pets = pets
                self.totalPetCount = pets.count
                self.updatePetsImageAndLabels()
            }
        }
    }
    
    
    func updatePetsImageAndLabels() {
        let pet = pets[index]
        let imageString = pet.petImage
        let petName = pet.petName
        let petAge = pet.petAge
        self.petNameLabel.text = petName
        self.petAgeLabel.text = petAge
        Storage.storage().reference(withPath: imageString).getData(maxSize: (1024 * 1024), completion: { (data, error) in
            guard let data = data else {
                NSLog("No data. \(error)")
                return
            }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.petPicture.image = image
                self.moveCardToMiddle()
            }
        })
    }
    
    func savePetAsPetCard(petCard: Pet) {
        _ = PetCard(dictionary: petCard.petDictionary)
        do {
            try Stack.context.save()
        } catch {
            print("Save to persistent storage failed")
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
            self.updatePetsImageAndLabels()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCornerAndShadow()
        petPicture.layer.cornerRadius = 25
        card.layer.cornerRadius = 25
        downloadAllPets()
    }

    @IBAction func unwindToMain(_ sender: UIStoryboardSegue) {}
}



