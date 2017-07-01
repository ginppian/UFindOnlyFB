//
//  AjustesTableViewCell.swift
//  UFind
//
//  Created by ginppian on 01/03/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import UIKit

class AjustesTableViewCell: UITableViewCell {

    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
