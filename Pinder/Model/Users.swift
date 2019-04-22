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
    init?(dictionary: [String: Any])
}

//name, email, phone, id

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

extension Users: DocumentUserSerializable {
    init?(dictionary: [String : Any]) {
        guard let id = dictionary["id"] as? String,
            let name = dictionary["name"] as? String,
            let email = dictionary["email"] as? String,
            let password = dictionary["password"] as? String,
            let phoneNumber = dictionary["phoneNumber"] as? Int else {return nil}
        self.init(id: id, name: name, email: email, password: password, phoneNumber: phoneNumber)
    }
}
