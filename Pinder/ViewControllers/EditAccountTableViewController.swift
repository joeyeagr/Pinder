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
    
    var pet: [Pet]?
    var db: Firestore!
    var currentAuthID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        getPersonalAccountData()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pet?.count ?? 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "petCell", for: indexPath) as? EditAccountTableViewCell else { return UITableViewCell() }
        tableView.rowHeight = 118
        
        return cell
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
                                // enter the header in here for the text to change.
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
