//
//  ViewController.swift
//  Pinder
//
//  Created by Joe Eagar on 3/22/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.


import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var petPicture: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    @IBAction func profileButton(_ sender: Any) {
    }
    @IBAction func likedPetsButton(_ sender: Any) {
    }
    @IBOutlet weak var petView: UIView!
    
    
    func setCornerAndShadow() {

        
        petPicture.clipsToBounds = true
        petView.clipsToBounds = true
        
        shadowView.backgroundColor = .clear
        shadowView.layer.masksToBounds = false
        
        shadowView.layer.shadowColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 2, height: 3)
        shadowView.layer.shadowRadius = 1.7
        shadowView.layer.shadowOpacity = 1.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCornerAndShadow()
        petPicture.layer.cornerRadius = 25
        petView.layer.cornerRadius = 25
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: petView.bounds, cornerRadius: 25).cgPath

    }


}

