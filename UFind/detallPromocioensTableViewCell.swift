//
//  detallPromocioensTableViewCell.swift
//  UFind
//
//  Created by ginppian on 12/03/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import UIKit

class detallPromocioensTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imagen: UIImageView!
    
    @IBOutlet weak var labelPromocion: UILabel!

    @IBOutlet weak var labelRestriccion: UILabel!
    
    @IBOutlet weak var labelVigencia: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
