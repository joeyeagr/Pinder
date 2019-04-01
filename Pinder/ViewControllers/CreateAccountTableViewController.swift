//
//  CreateAccountTableViewController.swift
//  Pinder
//
//  Created by Tyler Donohue on 3/28/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase

class CreateAccountTableViewController: UITableViewController {
    
    //Outlets
    @IBOutlet var humanNameTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    
    //variables
    var db: Firestore!
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var db = Firestore.firestore()
        
    }
    
    func createAccount(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil {
                print("Account Created")
                self.signInAccount(email: email, password: password)
            }
        }
    }
    
    func signInAccount(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil {
                print("Account Sign in")
                self.userDefault.set(true, forKey: "accountSignedIn")
                self.userDefault.synchronize()
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
    
    //Actions
    @IBAction func createAccountButtonTapped(_ sender: Any) {
    }
    
}
