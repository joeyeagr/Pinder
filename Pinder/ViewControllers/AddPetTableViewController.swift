//
//  AddPetTableViewController.swift
//  Pinder
//
//  Created by Tyler Donohue on 3/28/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import UIKit

class AddPetTableViewController: UITableViewController {
    @IBOutlet var petNameTF: UITextField!
    @IBOutlet var petBreedTF: UIView!
    @IBOutlet var petAgeTF: UITextField!
    @IBOutlet var genderControl: UISegmentedControl!
    @IBOutlet var bioTextView: UITextView!
    @IBOutlet var firstUIImage: UIImageView!
    @IBOutlet var secondUIImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
    
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    
    @IBAction func addImageButtonTapped(_ sender: Any) {
    }
    
    @IBAction func addImageButtonTapped2(_ sender: Any) {
    }
    
}
