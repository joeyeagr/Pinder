//
//  CreateAccountTableViewController.swift
//  TableTopMeetUp
//
//  Created by Tyler Donohue on 2/11/19.
//  Copyright © 2019 Tyler Donohue. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

class CreateAccountTableViewController: UITableViewController, UIImagePickerControllerDelegate{
    
    //Outlets
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var humanNameTF: UITextField!
    
    var db: Firestore!
    var userId: String = ""
    var emailField: String = ""
    var passwordField: String = ""
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    var username: String = ""
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.allowsEditing = true
        view.backgroundColor = UIColor(displayP3Red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
    }
    
    func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil {
                print("userCreated")
                self.signInUser(email: email, password: password)
            }
        }
    }
    
    func signInUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil {
                print("User Signed In")
                self.userDefault.set(true, forKey: "userSignedIn")
                self.userDefault.synchronize()
                self.performSegue(withIdentifier: "logIn", sender: nil)
            } else {
                print(error as Any)
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    func createData() {
        var id: String = ""
        var name: String = humanNameTF.text ?? "humanName"
        var email: String = emailTF.text ?? "HumanEmail"
        var password: String = passwordTF.text ?? "HumanPassword"
        var phoneNumber: Int = 0
        
        let user = Users(id: id,
                         name: name,
                         email: email,
                         password: password,
                         phoneNumber: phoneNumber)
        
        let userRef = self.db.collection("profile")
        
        userRef.document(String(user.id)).setData(user.dictionary){ err in
            if err != nil {
                print(Error.self)
            } else {
                print("Added Data")
            }
        }
    }
    
    //Actions
    @IBAction func createAccountTapped(_ sender: Any) {
        
        if let email = emailTF.text, let password = passwordTF.text {
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if error == nil {
                    let userReff = self.db.collection("profile").document("\(self.userId)")
                    self.createData()
                    print("userCreated")
                    self.signInUser(email: email, password: password)
                }
            }
        }
    }
    
}
