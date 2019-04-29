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

class AddPetTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
    let fileName = "HeraldVolazj.png"
    
    var imageReferance: StorageReference {
        return Storage.storage().reference().child("images")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPersonalAccountData()
        getCurrentDate()
    }
    
    func uploadPetImage() {
        
 
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        var imageRef: StorageReference {
            return Storage.storage().reference().child("petImages")
        }
        
        guard let image = firstUIImage.image else {return}
        guard let imageData = image.jpegData(compressionQuality: 0) else {return}
        
        let uploadImageRef = imageRef.child(fileName)
        let uploadTask = uploadImageRef.putData(imageData, metadata: nil) { (metadata, error) in
            print(metadata ?? "NO METADATA")
            print(error ?? "no error :)")
        }
        
        uploadTask.observe(.progress) { (snapshot) in
            print(snapshot.progress ?? "no more progress")
        }
        
        uploadTask.resume()
    }
    
    func getPersonalAccountData() {
        
        guard let uid: String = self.currentAuthID else { return }
        let profileRef = self.db.collection("profile").whereField("id", isEqualTo: uid)
        profileRef.getDocuments { (snapshot, error) in
            if error != nil {
                print(error)
            } else {
                for document in (snapshot?.documents)! {
                    if let name = document.data()["name"] as? String {
                        if let email = document.data()["email"] as? String {
                            if let phoneNumber = document.data()["phoneNumber"] as? Int {
                                self.humanNameLabel.text = name
                                self.emailLabel.text = email
                                self.phoneNumberLabel.text = String(phoneNumber)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getCurrentDate() -> String {
        
        let date = Date()
        let calander = Calendar.current
        let day = calander.component(.day, from: date)
        let month = calander.component(.month, from: date)
        let year = calander.component(.year, from: date)
        let currentLabel = ("\(month).\(day).\(year)")
        currentDateLabel.text = currentLabel
        return currentLabel
    }
    
    func createPetCardData() {
        
        //human data
        let humanName = humanNameLabel.text ?? "human name"
        let email = emailLabel.text ?? "email"
        let phoneNumber = phoneNumberLabel.text ?? "phone number"
        let humanId = currentAuthID ?? "randomlyGeneratedCode"
        
        let profileRef = self.db.collection("profile").document(humanId)
        
        //pet data
        let petName: String = petNameTF.text ?? "pet"
        let petBreed: String = petBreedTF.text ?? "breed"
        let petAge: Int = Int(petAgeTF.text ?? "age") ?? 0
        let petBio: String = bioTextView.text ?? "bio"
        let isMale: Bool = genderBenderControl
        let dateCreated: String = currentDateLabel.text ?? "date"
        let petImage1: String = ""
        let petImage2: String = "" // add referanc eto teh iamges here
        let petId: String
        let humanContact: Array<String> = [humanName, email, phoneNumber, humanId]
        
        let pet = Pet(petId: String(arc4random_uniform(999999999)),
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

        
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//
//        let alertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alertController.addAction(cancelAction)
//
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in
//                imagePicker.sourceType = .camera
//                self.present(imagePicker, animated: true, completion: nil)
//            })
//            alertController.addAction(cameraAction)
//        }
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { action in
//                imagePicker.sourceType = .photoLibrary
//                self.present(imagePicker, animated: true, completion: nil)
//
//            })
//            alertController.addAction(photoLibraryAction)
//        }
//        present(alertController, animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func addImageButtonTapped2(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        let alertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        present(alertController, animated: true, completion: nil)
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
