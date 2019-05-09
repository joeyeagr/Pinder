//
//  Animations.swift
//  Pinder
//
//  Created by Joe Eagar on 4/9/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import Firebase
import FirebaseStorage
import FirebaseFirestore

extension HomeViewController {
    
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        let scale = min(150/abs(xFromCenter), 1)
        
        card.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor).scaledBy(x: scale, y: scale)
        
                if xFromCenter > 0 {
            smileyImageView.image = UIImage(named: "SmileyFace")
            smileyImageView.tintColor = UIColor.green
        } else {
            smileyImageView.image = UIImage(named: "FrownyFace")
            smileyImageView.tintColor = UIColor.red
        }
        
        smileyImageView.alpha = abs(xFromCenter) / view.center.x
        
        if sender.state == UIGestureRecognizer.State.ended {
            
            if card.center.x < 75 {
                //move off to left side
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    card.alpha = 0
                }, completion: { _ in
                    self.resetCard(cardDismissed: true)
                })
                return
            } else if card.center.x > (view.frame.width - 75) {
                //move off to right side
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                }, completion: { _ in
                    self.resetCard(cardDismissed: true)
//                    self.savePetAsPetCard(petCard: self.pets[self.index])
                })
                return
            }
            moveCardToMiddle()
        }
    }
}
