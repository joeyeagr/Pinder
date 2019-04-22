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

protocol Identifiable {
    var id: String? { get set }
}

protocol DocumentUserSerializable {
    init?(humanDictionary: [String: Any])
}

//name, email, phone, id

struct Users {
    var id: String
    var name: String
    var email: String
    var password: String
    var phoneNumber: Int
    
    var humanDictionary: [String: Any] {
        return [
            "id": id,
            "name": name,
            "email": email,
            "password": password,
            "phoneNumber": phoneNumber
            
        ]
    }
}

extension Users {
    init?(humanDictionary: [String : Any]) {
        guard let id = humanDictionary["id"] as? String,
            let name = humanDictionary["name"] as? String,
            let email = humanDictionary["email"] as? String,
            let password = humanDictionary["password"] as? String,
            let phoneNumber = humanDictionary["phoneNumber"] as? Int else {return nil}
        self.init(id: id, name: name, email: email, password: password, phoneNumber: phoneNumber)
    }
}
