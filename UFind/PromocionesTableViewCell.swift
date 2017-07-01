//
//  PromocionesTableViewCell.swift
//  
//
//  Created by ginppian on 12/03/17.
//
//

import UIKit

class PromocionesTableViewCell: UITableViewCell {

    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var label: UILabel!
    var id = String()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
