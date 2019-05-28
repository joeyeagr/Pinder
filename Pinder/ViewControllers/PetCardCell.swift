//
//  PetCardCell.swift
//  Pinder
//
//  Created by Benjamin Poulsen PRO on 5/10/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import Firebase
import FirebaseStorage
import FirebaseFirestore


class PetCardCell: UICollectionViewCell {
    
    @IBOutlet weak var petCardImageView: UIImageView!
    
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var petAgeLabel: UILabel!
    
    
    static let sharedController = PetCardCell()
    
    var petImage: UIImage?
    
    var petCard: PetCard? {
        didSet {
            guard let petCard = petCard else {return}
            
        }
    }
    
    
    func updateUI(petCard: PetCard?) {
        guard let petCard = petCard else {return}
        let imageString = petCard.petImage
        Storage.storage().reference(withPath: imageString!).getData(maxSize: (1024 * 1024), completion: { (data, error) in
            guard let data = data else {
                NSLog("No data. \(error)")
                return
            }
            let image = UIImage(data: data)
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            imageView.image = image
            imageView.layer.cornerRadius = 25
            imageView.layer.masksToBounds = true
            //            imageView.sendSubviewToBack(self.petCardImageView)
            //            self.addSubview(imageView)
            self.petCardImageView.image = image
            self.petNameLabel.text = petCard.petName
            self.petAgeLabel.text = petCard.petAge
        })
        
    }
    
    
    override func layoutSubviews() {
        layer.shadowColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0).cgColor
        layer.shadowOffset = CGSize(width: 2, height: 3)
        layer.shadowRadius = 1.7
        layer.shadowOpacity = 1.0
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2.0
        layer.cornerRadius = 25
        
        
        
    }
    
    
    
    
    
    
    
    
}
