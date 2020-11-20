//
//  RiderInfoCell.swift
//  Angliru
//
//  Created by Juanra Fernández on 02/11/2020.
//  Copyright © 2020 JRLabs. All rights reserved.
//

import UIKit

class RiderInfoCell: UITableViewCell {

    @IBOutlet weak var imageViewCountry: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
