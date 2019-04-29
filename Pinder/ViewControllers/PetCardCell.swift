//
//  petCardCell.swift
//  Pinder
//
//  Created by Benjamin Poulsen PRO on 4/19/19.
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
    
    
    static let sharedController = PetCardCell()
    
    var petImage: UIImage?
    
    var petCard: PetCard? {
        didSet {
            guard let petCard = petCard else {return}
        }
    }
    
    
    func updateUI(petCard: PetCard?) {
        guard let petCard = petCard else {return}
        let imageString = petCard.petImage1
        Storage.storage().reference(withPath: imageString!).getData(maxSize: (1024 * 1024), completion: { (data, error) in
            guard let data = data else {
                NSLog("No data. \(error)")
                return
            }
            let image = UIImage(data: data)
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            imageView.image = image
            self.addSubview(imageView)
        })
    }
    
    
    override func layoutSubviews() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2.0
        layer.cornerRadius = 4.0
    }
    
    
    
    
    
    
    
    
}


