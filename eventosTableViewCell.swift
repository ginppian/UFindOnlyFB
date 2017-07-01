//
//  eventosTableViewCell.swift
//  UFind
//
//  Created by ginppian on 12/03/17.
//  Copyright © 2017 ginppian. All rights reserved.
//

import UIKit

class eventosTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelSubtitulo: UILabel!
    @IBOutlet weak var labelLugar: UILabel!
    @IBOutlet weak var labelFecha: UILabel!
    @IBOutlet weak var labelHora: UILabel!
    @IBOutlet weak var labelPuntosVenta: UILabel!
    @IBOutlet weak var labelPrecios: UILabel!
    var eventoId = String()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
