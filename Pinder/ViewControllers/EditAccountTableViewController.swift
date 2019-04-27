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
    }

    
    func getPersonalAccountData() {
        
        guard let uid: String = self.currentAuthID else { return }
        print("edit account \(uid)")
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
