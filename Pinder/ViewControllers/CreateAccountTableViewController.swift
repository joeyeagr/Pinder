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
    var currentAuthID = Auth.auth().currentUser?.uid
    var currentUser: User?
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logIn", let accountVC = segue.destination as? EditAccountTableViewController {
            
            accountVC.humanNameValue = humanNameTF.text ?? ""
            accountVC.humanEmailValue = emailTF.text ?? ""
        }
    }
    
    func createData() {
        guard let id: String = currentAuthID else { return }
        guard let name: String = humanNameTF.text  else { return }
        guard let email: String = emailTF.text  else { return }
        guard let password: String = passwordTF.text  else { return }
        guard let phoneNumber: Int = 0000000000  else { return }
        
        let user = Users(id: id,
                         name: name,
                         email: email,
                         password: password,
                         phoneNumber: phoneNumber)
        
        let userRef = self.db.collection("profile")
        
        userRef.document(String(user.id)).setData(user.humanDictionary){ err in
            if err != nil {
                print(Error.self)
            } else {
                print("Added Data")
            }
        }
    }
    
    //Actions
    @IBAction func createAccountTapped(_ sender: Any) {
        
        guard let email = emailTF.text else { return }
        guard let password = passwordTF.text else { return }
        guard let name = humanNameTF.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil || self.emailTF.text == "" || self.passwordTF.text == "" || self.humanNameTF.text == "" {
                UIView.animate(withDuration: 0.09, animations: {
                    let move = CGAffineTransform(translationX: 10, y: 0)
                    self.emailTF.transform = move
                    self.passwordTF.transform = move
                    self.humanNameTF.transform = move
                }) { (_) in
                    UIView.animate(withDuration: 0.09, animations: {
                        self.emailTF.transform = .identity
                        self.passwordTF.transform = .identity
                        self.humanNameTF.transform = .identity
                    })
                }
                print("Not Valid")
                print(error)
            } else {
                print(self.userId)
                self.createData()
                print("userCreated")
                self.signInUser(email: email, password: password)
                self.performSegue(withIdentifier: "logIn", sender: nil)
                print("Valid")
            }
        }
    }
    
}
