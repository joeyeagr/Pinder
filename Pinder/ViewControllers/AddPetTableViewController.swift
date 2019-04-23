//
//  AddPetTableViewController.swift
//  Pinder
//
//  Created by Tyler Donohue on 3/28/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class AddPetTableViewController: UITableViewController {
    @IBOutlet var petNameTF: UITextField!
    @IBOutlet var petBreedTF: UITextField!
    @IBOutlet var petAgeTF: UITextField!
    @IBOutlet var genderControl: UISegmentedControl!
    @IBOutlet var bioTextView: UITextView!
    @IBOutlet var firstUIImage: UIImageView!
    @IBOutlet var secondUIImage: UIImageView!
    @IBOutlet var currentDateLabel: UILabel!
    @IBOutlet var humanNameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    
    var db = Firestore.firestore()
    var currentAuthID = Auth.auth().currentUser?.uid
    var genderBenderControl: Bool = false
    let storage = Storage.storage()
    
    var humanName: String = ""
    var humanEmail: String = ""
    var humanPhoneNumber: String = "000-000-0000"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHumanAccountInfo()
        getCurrentDate()
    }
    
    // MARK: - Table view data source
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //
    //        return 0
    //    }
    //
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //
    //        return 0
    //    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    func getHumanAccountInfo() {
        humanNameLabel.text = humanName
        emailLabel.text = humanEmail
        phoneNumberLabel.text = humanPhoneNumber
    }
    
    func getCurrentDate() -> String {
        
        let date = Date()
        let calander = Calendar.current
        
        let day = calander.component(.day, from: date)
        let month = calander.component(.month, from: date)
        let year = calander.component(.year, from: date)
        
        var currentLabel = ("\(month).\(day).\(year)")
        currentDateLabel.text = currentLabel
        return currentLabel ?? "Current Date"
    }
    
    func createPetCardData() {
        
        let humanName = humanNameLabel.text ?? "human name"
        let email = emailLabel.text ?? "email"
        let phoneNumber = phoneNumberLabel.text ?? "phone number"
        let humanId = currentAuthID ?? "randomlyGeneratedCode"
        
        let petName: String = petNameTF.text ?? "pet"
        let petBreed: String = petBreedTF.text ?? "breed"
        let petAge: Int = Int(petAgeTF.text ?? "age") ?? 0
        let petBio: String = bioTextView.text ?? "bio"
        let isMale: Bool = genderBenderControl
        let dateCreated: String = currentDateLabel.text ?? "date"
        let petImage1: UIImage? = firstUIImage.image
        let petImage2: UIImage? = secondUIImage.image
        let petId: String
        let humanContact: Array<String> = [humanName, email, phoneNumber, humanId]
        
        let pet = Pet(petId: String(arc4random_uniform(9000000)),
                      petName: petName,
                      petBreed: petBreed,
                      petAge: petAge,
                      isMale: isMale,
                      petBio: petBio,
                      date: dateCreated,
                      petImage1: petImage1,
                      petImage2: petImage2,
                      humanContact: humanContact)
        
        let userRef = self.db.collection("PetId")
        
        userRef.document(String(pet.petId)).setData(pet.petDictionary){ err in
            if err != nil {
                print(Error.self)
            } else {
                print("Added Data")
            }
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        createPetCardData()
    }
    
    @IBAction func addImageButtonTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Choose Image",
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        let cameraAction = UIAlertAction(title: "Camera",
                                         style: .default,
                                         handler: { action in
            print("User selected Camera action")})
        let photoLibraryAction = UIAlertAction(title: "PhotoLibrary",
                                               style: .default,
                                               handler: { action in
            print("User selected Photo Library action")})
        alertController.addAction(cancelAction)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.popoverPresentationController?.sourceView = sender as? UIView
        present(alertController,
                animated: true,
                completion: nil)
    }
    
    @IBAction func addImageButtonTapped2(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Choose Image",
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        let cameraAction = UIAlertAction(title: "Camera",
                                         style: .default,
                                         handler: { action in
            print("User selected Camera action")})
        let photoLibraryAction = UIAlertAction(title: "PhotoLibrary",
                                               style: .default,
                                               handler: { action in
            print("User selected Photo Library action")})
        alertController.addAction(cancelAction)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.popoverPresentationController?.sourceView = sender as? UIView
        present(alertController,
                animated: true,
                completion: nil)
    }
    
    @IBAction func genderControlTapped(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            genderBenderControl = false
            print("male")
            break;
        case 1:
            genderBenderControl = true
            print("female")
            break;
        default:
            genderBenderControl = false
        }
    }
    
}
