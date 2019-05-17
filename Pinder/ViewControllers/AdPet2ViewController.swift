//
//  AdPet2ViewController.swift
//  Pinder
//
//  Created by Benjamin Poulsen PRO on 5/13/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class AdPet2ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet var petNameTF: UITextField!
    @IBOutlet var petBreedTF: UITextField!
    @IBOutlet var petAgeTF: UITextField!
    @IBOutlet var genderControl: UISegmentedControl!
    @IBOutlet var bioTextView: UITextView!
    @IBOutlet var firstUIImage: UIImageView!
    @IBOutlet var currentDateLabel: UILabel!
    @IBOutlet var humanNameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    
    var db = Firestore.firestore()
    var currentAuthID = Auth.auth().currentUser?.uid
    var genderBEnderControl: Bool = false
    let storage = Storage.storage()
    let fileName2 = String(arc4random_uniform(999999999)) + "Pet"
    var imageRef: StorageReference {
        return Storage.storage().reference().child("petImages")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentDate()
        getPersonalAccountData()
        createPetCardData()
        changeBackground()
        // Do any additional setup after loading the view.
    }
    
    func changeBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Gradient")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func uploadPetImage() {
        
        guard let image = firstUIImage.image else {return}
        guard let imageData = image.jpegData(compressionQuality: 0) else {return}
        
        let uploadImageRef = imageRef.child(fileName2)
        let uploadTask = uploadImageRef.putData(imageData, metadata: nil) { (metadata, error) in
            print(metadata ?? "no metadata")
        }
        uploadTask.resume()
        
    }
    
    func getCurrentDate() -> String {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let currentLabel = ("\(month).\(day).\(year)")
        currentDateLabel.text = currentLabel
        return currentLabel
    }
    
    func getPersonalAccountData() {
        
        guard let uid: String = self.currentAuthID else { return }
        print("this is my uid i really like my uid \(uid)")
        let profileRef = self.db.collection("profile").whereField("id", isEqualTo: uid)
        profileRef.getDocuments { (snapshot, error) in
            if error != nil {
                print(error as Any)
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

    func createPetCardData() {
        
        // human data
        let humanName = humanNameLabel.text ?? "human name"
        let email = emailLabel.text ?? "email"
        let phoneNumber = phoneNumberLabel.text ?? "phone number"
        let humanUID = currentAuthID ?? "randomGenCode"
        
        //pet data
        let petName: String = petNameTF.text ?? "pet"
        let petBreed: String = petBreedTF.text ?? "breed"
        let petAge: String = petAgeTF.text ?? "age"
        let petBio: String = bioTextView.text ?? "bio"
        let isMale: Bool = genderBEnderControl
        let dateCreated: String = currentDateLabel.text ?? "date"
        let petImage: String = fileName2
        let humanContact: Array<String> = [humanName, email, phoneNumber]
        let humanId: String = humanUID
        
        let pet = Pet(petId: String(arc4random_uniform(999999999)),
            petName: petName,
            petBreed: petBreed,
            petAge: petAge,
            isMale: isMale,
            petBio: petBio,
            date: dateCreated,
            petImage: petImage,
            humanContact: humanContact,
            humanId: humanId)
        
        let userRef = self.db.collection("PetId")
        
        userRef.document(String(pet.petId)).setData(pet.petDictionary){ err in
            if err != nil {
                print(Error.self)
            } else {
                print("added data")
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError()
        }
        firstUIImage.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        uploadPetImage()
        createPetCardData()
        let alert = UIAlertController(title: "Your pet card was saved", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func petImageTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func genderControllerTapped(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            genderBEnderControl = false
            break;
        case 1:
            genderBEnderControl = true
            break;
        default:
            genderBEnderControl = false
        }
    }
    
    
}
