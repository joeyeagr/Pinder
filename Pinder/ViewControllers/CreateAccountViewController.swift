//
//  CreateAccountViewController.swift
//  Pinder
//
//  Created by Tyler Donohue on 5/10/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class CreateAccountViewController: UIViewController {
    
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var humanNameTF: UITextField!
    @IBOutlet var phoneNumberTF: UITextField!
    @IBOutlet var logInEmail: UITextField!
    @IBOutlet var logInPassword: UITextField!
    
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
        changeBackground()
    }
    
    func changeBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Gradient")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func createUser() {
        
        guard let email = emailTF.text else { return }
        guard let password = passwordTF.text else { return }

        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil || self.emailTF.text == "" || self.passwordTF.text == "" || self.humanNameTF.text == "" || self.phoneNumberTF.text == "" {
                UIView.animate(withDuration: 0.09, animations: {
                    let move = CGAffineTransform(translationX: 10, y: 0)
                    self.emailTF.transform = move
                    self.passwordTF.transform = move
                    self.humanNameTF.transform = move
                    self.phoneNumberTF.transform = move
                }) { (_) in
                    UIView.animate(withDuration: 0.09, animations: {
                        self.emailTF.transform = .identity
                        self.passwordTF.transform = .identity
                        self.humanNameTF.transform = .identity
                        self.phoneNumberTF.transform = .identity
                    })
                }
                print("Not Valid")
                print(error)
            } else {
                print("User Created")
            }
        }
    }
    
    func signIn() {
        
        guard let email = emailTF.text else { return }
        guard let password = passwordTF.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if user != nil {
                print("uid")
                //self.performSegue(withIdentifier: "logIn", sender: self)
            } else {
                let alert = UIAlertController(title: "Error Logging In", message: nil, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                print("no uid")
                return
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "logIn", let editAccountVC = segue.destination as? EditAccountTableViewController {
            
            editAccountVC.humanName = humanNameTF.text ?? "name"
            editAccountVC.phoneNumber = Int(phoneNumberTF.text ?? "01") ?? 0
            editAccountVC.email = emailTF.text ?? "email"
            editAccountVC.password = passwordTF.text ?? "password"
            editAccountVC.currentAuthID = currentAuthID
        }
        print("prepare for segueSearch called")
    }
    
    func createData() {
        
        let stringNumber = phoneNumberTF.text ?? "0000000000"
        guard let id: String = self.currentAuthID else { return }
        print(id)
        guard let name: String = humanNameTF.text  else { return }
        print(name)
        guard let email: String = emailTF.text  else { return }
        print(email)
        guard let password: String = passwordTF.text  else { return }
        print(password)
        guard let phoneNumber: Int = Int(stringNumber)  else { return }
        print(phoneNumber)
        
        let user = Users(id: id,
                         name: name,
                         email: email,
                         password: password,
                         phoneNumber: phoneNumber)
        
        let userRef = self.db.collection("profile")
        userRef.document(String(user.id)).setData(user.humanDictionary){ error in
            if error == nil {
                print("Added Human Data")
                print("call, UserID: \(self.currentAuthID)")
            } else {
                print("you have an error in creating data")
                print(Error.self)
            }
        }
    }
    
    //Actions
    @IBAction func createAccountTapped(_ sender: Any) {
    //    DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.createUser()
     //   }
        if currentAuthID != nil {
            self.createData()
            self.performSegue(withIdentifier: "logIn", sender: nil)
        } else {
            print("error, no uid detected")
        }
        
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        
        guard let email = logInEmail.text else {return}
        guard let password = logInPassword.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "logIn", sender: self)
            } else {
                let alert = UIAlertController(title: "Error Logging In", message: nil, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        
    }
    
    @IBAction func unwindToLogIn(_ sender: UIStoryboardSegue) {}
    
    
}
