//
//  EditAccountTableViewController.swift
//  Pinder
//
//  Created by Tyler Donohue on 3/28/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class EditAccountTableViewController: UITableViewController {
    @IBOutlet var humanNameLabel: UILabel!
    @IBOutlet var selfEmailLabel: UILabel!
    @IBOutlet var selfPhoneNumberLabel: UILabel!
    
    var db: Firestore!
    var currentAuthID = Auth.auth().currentUser?.uid
    var humanNameValue: String = ""
    var humanEmailValue: String = ""
    var humanPhoneNumberValue: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        getPersonalAccountData()
//        getHumanAccountInfo()
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell... performSegue(withIdentifier: "segueSearch", sender: nil)

        return cell
    }
    */
    
    func getPersonalAccountData() {
        
        guard let id: String = currentAuthID else { return }
        print(id)

        let profileRef = self.db.collection("profile").whereField("id", isEqualTo: id)
        profileRef.getDocuments { (snapshot, error) in
            if error != nil {
                print(error)
            } else {
                for document in (snapshot?.documents)! {
                    if let name = document.data()["name"] as? String {
                        if let email = document.data()["email"] as? String {
                            if let phoneNumber = document.data()["phoneNumber"] as? Int {
                                self.humanNameLabel.text = name
                                self.selfEmailLabel.text = email
                                self.selfPhoneNumberLabel.text = String(phoneNumber)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func addPetButtonTapped(_ sender: Any) {
        
         performSegue(withIdentifier: "addPet", sender: nil)
    }
    
    @IBAction func logOutTapped(_ sender: Any) { //this isnt working correctly
        self.currentAuthID = nil
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("User Signed Out")
            print(currentAuthID)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    @IBAction func unwindToEditAccount(_ sender: UIStoryboardSegue) {}
    
}
