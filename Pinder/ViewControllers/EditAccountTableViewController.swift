//
//  EditAccountTableViewController.swift
//  Pinder
//
//  Created by Tyler Donohue on 3/28/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import UIKit

class EditAccountTableViewController: UITableViewController {
    @IBOutlet var humanNameLabel: UILabel!
    @IBOutlet var selfEmailLabel: UILabel!
    @IBOutlet var selfPhoneNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPet", let addPetVC = segue.destination as? AddPetTableViewController {
            
            addPetVC.humanNameLabel = humanNameLabel
            addPetVC.emailLabel = selfEmailLabel
            addPetVC.phoneNumberLabel = selfPhoneNumberLabel
        }
    }
    
    @IBAction func addPetButtonTapped(_ sender: Any) {
         performSegue(withIdentifier: "addPet", sender: nil)
    }
    
}
