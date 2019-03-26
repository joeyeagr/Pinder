//
//  ViewController.swift
//  Pinder
//
//  Created by Joe Eagar on 3/22/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.


import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var petPicture: UIImageView!
    
    func setCornerAndShadow() {
        
        petPicture.layer.cornerRadius = 50
        petPicture.layer.shadowColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        petPicture.layer.shadowOffset = CGSize(width: 10, height: 10)
        petPicture.layer.shadowRadius = 10.0
        petPicture.layer.shadowOpacity = 1.0
//        petPicture.layer.shadowPath = UIBezierPath(roundedRect: petPicture.bounds, cornerRadius: 12).cgPath
        petPicture.clipsToBounds = true
//        petPicture.layer.masksToBounds = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCornerAndShadow()
        
        
        
    }
    
    
}

