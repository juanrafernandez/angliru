//
//  RiderInfoViewController.swift
//  Angliru
//
//  Created by Juanra Fernández on 06/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit

class RiderInfoViewController: BaseViewController {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAge: UILabel!
    @IBOutlet weak var labelAgeInfo: UILabel!
    @IBOutlet weak var labelHeight: UILabel!
    @IBOutlet weak var labelHeightInfo: UILabel!
    @IBOutlet weak var labelWeight: UILabel!
    @IBOutlet weak var labelWeightInfo: UILabel!
    @IBOutlet weak var labelBirthPlace: UILabel!
    @IBOutlet weak var labelBirthPlaceInfo: UILabel!
    @IBOutlet weak var imageViewCountry: UIImageView!
    @IBOutlet weak var labelTeam: UILabel!
    @IBOutlet weak var buttonTeam: UIButton!
    @IBOutlet weak var labelRRSS: UILabel!
    @IBOutlet weak var buttonRRSS1: UIButton!
    @IBOutlet weak var buttonRRSS2: UIButton!
    @IBOutlet weak var buttonRRSS3: UIButton!
    
    var rider : Rider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (rider != nil) {
            labelName.text = rider.name
            labelAgeInfo.text = rider.age
            labelHeightInfo.text = rider.height
            labelWeightInfo.text = rider.weight
            labelBirthPlaceInfo.text = rider.birthPlace
            buttonTeam.setTitle(rider.team, for: .normal)
            imageViewCountry.image = UIImage(named: rider.country)
        }
    }
    
    @IBAction func buttonBack_clicked(_ sender: Any) {
        self.navigationController! .popViewController(animated: true)
    }
    
    @IBAction func buttonTeam_clicked(_ sender: Any) {
    }
    
    @IBAction func buttonRRSS1_clicked(_ sender: Any) {
    }
    
    @IBAction func buttonRRSS2_clicked(_ sender: Any) {
    }
    
    @IBAction func buttonRRSS3_clicked(_ sender: Any) {
    }
    
}
