//
//  FirebaseController.swift
//  Pinder
//
//  Created by Tyler Donohue on 3/26/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class FirebaseController {
    
    static let shared = FirebaseController()
    var db = Firestore.firestore()
    var currentAuthID = Auth.auth().currentUser?.uid
    var currentUser: User?
    var userId: String? = ""
    var dbRef: DatabaseReference! = Database.database().reference()
    var storage = Storage.storage().reference()
    private var listenHandler: AuthStateDidChangeListenerHandle?
    var currentUpload:StorageUploadTask?
    
    func addUserListender(loggedIn: Bool) {
        print("Add listener")
        listenHandler = Auth.auth().addStateDidChangeListener{ (auth, user) in
            if user == nil {
                //logged Out
                print("You Are Currently Logged Out")
                self.currentUser = nil
                self.userId = ""
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    if loggedIn {
                        print("logged in")
                        //perform a segue here
                    } else {
                        print("not logged in")
                        //perform a segue here
                    }
                }
            } else {
                // check for docuemnt named the same as their user id, if it does not exist it will create a document for them to use, otherwise nothing will happen. should should only be called once when they user logs in and never again unless their account is deleted.
                print("Logged In")
                let userReff = self.db.collection("profile").document("\(self.userId)")
                userReff.getDocument { (document, error) in
                    if let document = document {
                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                        print("data already added: \(dataDescription)")
                    } else {
                      //  self.createData()
                        print("document added to fireStore")
                    }
                    self.currentUser = user
                    self.userId = (user?.uid)!
                    print("UserID: \(self.userId)")
                    //load data here
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        // perform some kind of segue here
                    }
                }
            }
        }
    }
    
    // creates blanks in firestore
    
    func createData() {
        var id: String = ""
        var name: String = ""
        var email: String = ""
        var password: String = ""
        var phoneNumber: Int = 0
        
        let user = Users(id: id,
                         name: name,
                         email: email,
                         password: password,
                         phoneNumber: phoneNumber)
        
        let userRef = self.db.collection("profile")
        
        userRef.document(String(user.id)).setData(user.humanDictionary){ err in
            if err != nil {
                print(Error.self)
            } else {
                print("Added Data")
            }
        }
    }
    
    func isLoggedIn() -> Bool {
        return(currentUser != nil)
    }
    
    func removeUserListener() {
        guard listenHandler != nil else {
            return
        }
        Auth.auth().removeStateDidChangeListener(listenHandler!)
    }
    
    func liknCredential(credential: AuthCredential) {
        currentUser?.linkAndRetrieveData(with: credential) {
            (user, error) in
            
            if let error = error {
                print(error)
                return
            }
            print("Credential linked")
        }
    }

    
    func logOut() {
        try! Auth.auth().signOut()
    }
    
}
