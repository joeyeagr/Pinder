//
//  EditAccountTableViewController.swift
//  Pinder
//
//  Created by Tyler Donohue on 3/28/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore


class EditAccountTableViewController: UITableViewController {
  
    var pets: [Pet]?
    var db: Firestore!
    var currentAuthID = Auth.auth().currentUser?.uid

    var phoneNumber: Int = 0
    var humanName: String = ""
    var email: String = ""
    var password: String = ""
    var userId: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var pets = [Pet]()
        getPetData()
        changeBackground()
        db = Firestore.firestore()
        checkFirestoreForUserDocument()
        getPersonalAccountData()
        
    }
    
    func changeBackground() {
            let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.image = UIImage(named: "Gradient")
            backgroundImage.contentMode = UIView.ContentMode.scaleToFill
            self.tableView.backgroundView = backgroundImage
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        return headerView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "petCell", for: indexPath) as? EditAccountTableViewCell else { return UITableViewCell() }
        tableView.rowHeight = 80
        
        if let pets = pets {
            let pet = pets[indexPath.row]
            cell.petNameLabel?.text = "Pet Name: \(pet.petName)"
            cell.updateCell(pets: pet)
        } else {
            print("no pets")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            pets?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
    func checkFirestoreForUserDocument() {
        if humanName == "" || password == "" || email == "" {
            print("data already added")
        } else {
            createData()
        }
    }
    
    func createData() {
        
        guard let id: String = self.currentAuthID else { return }
        print(id)
        guard let name: String = humanName  else { return }
        print(name)
        guard let email: String = email  else { return }
        print(email)
        guard let password: String = password  else { return }
        print(password)
        guard let phoneNumber: Int = Int(phoneNumber)  else { return }
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
    
    func getPersonalAccountData() {
        // will be used later when we give options to the user to edit their personal account
        guard let uid: String = self.currentAuthID else { return }
        print("edit account \(uid)")
        let profileRef = self.db.collection("profile").whereField("id", isEqualTo: uid)
        profileRef.getDocuments { (snapshot, error) in
            if error != nil {
                print(error as Any)
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
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getPetData() {
        
        let db = Firestore.firestore()
        var pets = [Pet]()
        guard let petsId: String = self.currentAuthID else { return }

        db.collection("PetId").whereField("humanId", isEqualTo: petsId).getDocuments { (snapshot, error) in
            if error != nil {
                print("an error \(error)")
            } else {
                guard let snapshot = snapshot else {
                    print("could not unrwap snapshot")
                    return
                }
                for document in (snapshot.documents) {
                    if let name = document.data() as? [String: Any], let otherPets = Pet.init(petDictionary: name) {
                        pets.append(otherPets)
                    }
                }
                self.pets = pets
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func AddPet(_ sender: UIBarButtonItem) {
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
