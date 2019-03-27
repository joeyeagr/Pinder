//
//  Users.swift
//  Pinder
//
//  Created by Tyler Donohue on 3/26/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import Firebase

struct Users {
    var id: String
    var name: String
    var email: String
    var password: String
    var phoneNumber: Int
    
    var dictionary: [String: Any] {
        return [
            
            "id": id,
            "name": name,
            "email": email,
            "password": password,
            "phoneNumber": phoneNumber
        
        ]
    }
}
