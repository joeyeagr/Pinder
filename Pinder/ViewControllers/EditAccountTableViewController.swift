//
//  EditAccountTableViewController.swift
//  Pinder
//
//  Created by Tyler Donohue on 3/28/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import UIKit
import FirebaseAuth


class EditAccountTableViewController: UITableViewController {
    @IBOutlet var humanNameLabel: UILabel!
    @IBOutlet var selfEmailLabel: UILabel!
    @IBOutlet var selfPhoneNumberLabel: UILabel!
    
    var humanNameValue: String = ""
    var humanEmailValue: String = ""
    var humanPhoneNumberValue: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getHumanAccountInfo()
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
    
    func getHumanAccountInfo() {
        humanNameLabel.text = humanNameValue
        selfEmailLabel.text = humanEmailValue
        selfPhoneNumberLabel.text = humanPhoneNumberValue
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPet", let addPetVC = segue.destination as? AddPetTableViewController {
            
            addPetVC.humanName = humanNameLabel.text ?? ""
            addPetVC.humanEmail = selfEmailLabel.text ?? ""
            addPetVC.humanPhoneNumber = selfPhoneNumberLabel.text ?? "0000000000"
        }
    }
    
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
