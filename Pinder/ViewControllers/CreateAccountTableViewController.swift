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

class CreateAccountTableViewController: UITableViewController, UIImagePickerControllerDelegate{
    
    //Outlets
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var humanNameTF: UITextField!
    
    var userId: String = ""
    var emailField: String = ""
    var passwordField: String = ""
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    var username: String = ""
    let userDefault = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.allowsEditing = true
        view.backgroundColor = UIColor(displayP3Red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
    }
    
    
    
    // if requirements to search are not met
    
    //Actions
    @IBAction func createAccountTapped(_ sender: Any) {
    performSegue(withIdentifier: "logIn", sender: nil)
        
    }
    
    }
