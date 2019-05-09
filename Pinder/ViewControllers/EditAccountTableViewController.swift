//
//  EditAccountTableViewController.swift
//  Pinder
//
//  Created by Tyler Donohue on 3/28/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class EditAccountTableViewController: UITableViewController {
  
    var pets: [Pet]?
    var db: Firestore!
    var currentUser: User?
    var currentAuthID = Auth.auth().currentUser?.uid
    
    var phoneNumber: Int = 0
    var humanName: String = ""
    var email: String = ""
    var password: String = ""
    var userId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         var pets = [Pet]()
        
        changeBackground()
        db = Firestore.firestore()
        getPersonalAccountData()
        print(currentAuthID)
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets?.count ?? 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "petCell", for: indexPath) as? EditAccountTableViewCell else { return UITableViewCell() }
        tableView.rowHeight = 118
        
        if let pets = pets {
            
            let pet = pets[indexPath.row]
            cell.petNameLabel?.text = "\(pet.petName)"
         //   cell.updateCell(pets: pet)
        }
        
        return cell
    }
    func checkForDocument() {
        
        if currentAuthID == nil {
            print("you are not logged in")
        } else {
            let userRef = self.db.collection("profile").document("\(String(describing: self.userId))")
            userRef.getDocument { (document, error) in
                if let document = document {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("data lready added: \(dataDescription)")
                } else {
                    self.createData()
                    print("document added to Firestore")
                }
                self.userId = self.currentAuthID ?? "no uid"
            }
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
     //   self.pets = pets
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getPetData() {
        
        var pets = [Pet]()
        guard let petsId: String = self.currentAuthID else { return }
        print("edit pet account \(petsId)")
        let profileRef = self.db.collection("PetId").whereField("humanId", isEqualTo: petsId)
        profileRef.getDocuments { (snapshot, error) in
            if error != nil {
                print(error)
            } else {
                guard let snapshot = snapshot else {
                    print("could not unrwap snapshot")
                    return
                }
                for document in (snapshot.documents) {
                    if let name = document.data()["name"] as? [String: Any], let otherPets = Pet.init(petDictionary: name) {
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
    
    @IBAction func addPetButtonTapped(_ sender: Any) {
        
         performSegue(withIdentifier: "addPet", sender: nil)
    }
    
    @IBAction func logOutTapped(_ sender: Any) { //this isnt working correctly
        self.currentAuthID = nil
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("User Signed Out")
            print(currentAuthID ?? "No Current UID Detected")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func unwindToAccount(_ sender: UIStoryboardSegue) {}
    
}

