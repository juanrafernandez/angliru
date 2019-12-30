//
//  CalendarInfoCell.swift
//  Angliru
//
//  Created by Juanra Fernández on 30/12/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit

class CalendarInfoCell : UITableViewCell {
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var viewTarget: UIView!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var labelYear: UILabel!
    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var labelRaceName: UILabel!
    @IBOutlet weak var labelRaceDate: UILabel!
    @IBOutlet weak var labelRaceType: UILabel!
    @IBOutlet weak var imageViewCountry: UIImageView!
    @IBOutlet weak var labelRaceDistance: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var labelStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewTarget.layer.cornerRadius = 10
        viewShadow.layer.cornerRadius = 10
        viewStatus.layer.cornerRadius = 10
        
        viewShadow.layer.shadowColor = UIColor.gray.cgColor
        viewShadow.layer.shadowOpacity = 0.3
        viewShadow.layer.shadowOffset = CGSize.zero
        viewShadow.layer.shadowRadius = 6
    }
}
