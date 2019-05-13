//
//  EditAccountTableViewCell.swift
//  Pinder
//
//  Created by Joe Eagar on 4/29/19.
//  Copyright © 2019 Joe Eagar. All rights reserved.
//

import UIKit
class EditAccountTableViewCell: UITableViewCell {
    
    @IBOutlet var petNameLabel: UILabel!
    
    var pets: [Pet]?
    var petName: String = ""
    var petAge: String = ""
    var petBreed: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateCell(pets: Pet) {
    }
}
