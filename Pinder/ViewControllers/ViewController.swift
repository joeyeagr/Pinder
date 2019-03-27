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
    
    func setCornerAndShadow() {

        petPicture.layer.cornerRadius = 50
        petPicture.clipsToBounds = true
        
        shadowView.backgroundColor = .clear
        shadowView.layer.masksToBounds = false
        
        shadowView.layer.shadowColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 10, height: 10)
        shadowView.layer.shadowRadius = 10.0
        shadowView.layer.shadowOpacity = 1.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCornerAndShadow()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: petPicture.bounds, cornerRadius: 50).cgPath
        
    }
    
    
}

