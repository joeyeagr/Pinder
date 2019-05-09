//
//  DetailViewController.swift
//  Pinder
//
//  Created by Benjamin Poulsen PRO on 4/25/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import Firebase
import FirebaseStorage
import FirebaseFirestore

class DetailViewController: UIViewController {
    
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var yupButton: UIButton!
    @IBOutlet weak var nopeButton: UIButton!
    
    
    var petCardArray: [PetCard?] = []
    var index: Int = 0
    var petCard: PetCard?
    static let sharedController = DetailViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        requestAllPetCardsImages()
    }
    
    
    func requestAllPetCardsImages() {
        RequestAllPetCardsFromFirestore { (petCards) in
            
            DispatchQueue.main.async {
                self.petCardArray = petCards
            }
        }
    }
    
    
    func updatePetCardImage() {
        let petCard = petCardArray[index]
        let imageString = petCard?.petImage
        Storage.storage().reference(withPath: imageString!).getData(maxSize: (1024 * 1024), completion: { (data, error) in
            guard let data = data else {
                NSLog("No data. \(error)")
                return
            }
            let image = UIImage(data: data)
            
            if let petImage = self.petImage {
                self.petImage.image = image
            }
        })
    }
    
    
    func RequestAllPetCardsFromFirestore(completion: (([PetCard?]) -> Void)? = nil) {
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
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func yupButtonTapped(_ sender: Any) {
        index += 1
        updatePetCardImage()
    }
    
    
    @IBAction func nopeButtonTapped(_ sender: Any) {
        
    }
    
    
    
    
    
    
    
    
    
}
