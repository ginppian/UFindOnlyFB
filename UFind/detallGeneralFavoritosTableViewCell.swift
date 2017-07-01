//
//  detallGeneralFavoritosTableViewCell.swift
//  UFind
//
//  Created by ginppian on 12/03/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import UIKit

class detallGeneralFavoritosTableViewCell: UITableViewCell {

    @IBOutlet weak var imagen: UIImageView!
    var favoritoActivo = Bool(false)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
