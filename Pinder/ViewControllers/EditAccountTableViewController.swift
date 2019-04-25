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
        
        let humanId = currentAuthID ?? "randomlyGeneratedCode"
        let profileRef = self.db.collection("profile").whereField("id", isEqualTo: currentAuthID)
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
    
//    func getHumanAccountInfo() {
//        humanNameLabel.text = humanNameValue
//        selfEmailLabel.text = humanEmailValue
//        selfPhoneNumberLabel.text = humanPhoneNumberValue
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "addPet", let addPetVC = segue.destination as? AddPetTableViewController {
//
//            let humanId = currentAuthID ?? "randomlyGeneratedCode"
//            let profileRef = self.db.collection("profile").document(humanId)
//
//            addPetVC.humanName = ""
//            addPetVC.humanEmail = selfEmailLabel.text ?? ""
//            addPetVC.humanPhoneNumber = selfPhoneNumberLabel.text ?? "0000000000"
//        }
//    }
    
    @IBAction func addPetButtonTapped(_ sender: Any) {
         performSegue(withIdentifier: "addPet", sender: nil)
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("User Signed Out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    @IBAction func unwindToEditAccount(_ sender: UIStoryboardSegue) {}
    
}
