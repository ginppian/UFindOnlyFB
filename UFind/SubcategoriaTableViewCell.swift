//
//  SubcategoriaTableViewCell.swift
//  UFind
//
//  Created by ginppian on 06/03/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import UIKit

class SubcategoriaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var direccion: UILabel!
    @IBOutlet weak var telefono: UILabel!
    @IBOutlet weak var distancia: UILabel!
    var id = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
