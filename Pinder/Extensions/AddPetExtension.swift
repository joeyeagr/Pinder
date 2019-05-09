//
//  AddPetExtension.swift
//  Pinder
//
//  Created by Tyler Donohue on 4/12/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import Foundation
import UIKit

extension AddPetViewController {
    
    func selectPetImage() {
        let picker = UINavigationController()
        
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
    }
    
}
