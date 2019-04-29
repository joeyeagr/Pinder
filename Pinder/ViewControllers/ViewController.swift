//
//  ViewController.swift
//  Pinder
//
//  Created by Joe Eagar on 3/22/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.


import UIKit
import Foundation
import CoreData
import Firebase
import FirebaseStorage
import FirebaseFirestore

class ViewController: UIViewController {
    
    @IBOutlet weak var petPicture: UIImageView!
    @IBAction func profileButton(_ sender: Any) {
    }
    @IBAction func likedPetsButton(_ sender: Any) {
    }
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var petAgeLabel: UILabel!
    @IBOutlet weak var smileyImageView: UIImageView!
    
    @IBOutlet weak var card: UIView!
    
    @IBAction func resetButton(_ sender: UIButton) {
        resetCard()
    }
    
    var divisor: CGFloat!
    
    
    func setCornerAndShadow() {
        petPicture.clipsToBounds = true
        
        card.layer.shadowColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        card.layer.shadowOffset = CGSize(width: 2, height: 3)
        card.layer.shadowRadius = 1.7
        card.layer.shadowOpacity = 1.0
    }
    
    func resetCard() {
        UIView.animate(withDuration: 0.2, animations: {
            self.card.center = self.view.center
            self.smileyImageView.alpha = 0
            self.card.alpha = 1
            self.card.transform = .identity
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCornerAndShadow()
        petPicture.layer.cornerRadius = 25
        card.layer.cornerRadius = 25
        divisor = (view.frame.width / 2) / 0.61
    }

}


