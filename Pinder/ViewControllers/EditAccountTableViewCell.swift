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
    let petName: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func updateCell(pets: Pet) {
        
    }
}
