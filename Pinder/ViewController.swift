//
//  ViewController.swift
//  Pinder
//
//  Created by Joe Eagar on 3/22/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var petPicture: UIImageView!
    
    func setCornerRounds() {
        petPicture.layer.cornerRadius = 50.0
        petPicture.layer.masksToBounds = true
        petPicture.layer.shadowColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        petPicture.layer.shadowOffset = CGSize(width: 0, height: 1.75)
        petPicture.layer.shadowRadius = 1.7
        petPicture.layer.shadowOpacity = 0.45
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCornerRounds()

    }
    
    
}

