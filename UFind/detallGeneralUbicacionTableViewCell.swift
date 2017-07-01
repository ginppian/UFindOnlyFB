//
//  detallGeneralUbicacionTableViewCell.swift
//  UFind
//
//  Created by ginppian on 12/03/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import UIKit

class detallGeneralUbicacionTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var imagen: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tintColor = UIColor.orange
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
