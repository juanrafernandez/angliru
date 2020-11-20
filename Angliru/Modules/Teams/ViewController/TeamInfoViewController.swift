//
//  TeamInfoViewController.swift
//  Angliru
//
//  Created by Juanra Fernández on 05/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit

class TeamInfoViewController: UIViewController {
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageViewTeamLogo: UIImageView!
    @IBOutlet weak var imageViewTeamCountry: UIImageView!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var labelCategoryInfo: UILabel!
    @IBOutlet weak var labelDirector: UILabel!
    @IBOutlet weak var labelDirectorInfo: UILabel!
    @IBOutlet weak var labelWeb: UILabel!
    @IBOutlet weak var buttonWeb: UIButton!
    @IBOutlet weak var labelRRSS: UILabel!
    @IBOutlet weak var buttonTwitter: UIButton!
    @IBOutlet weak var labelRiders: UILabel!
    @IBOutlet weak var buttonShowRiders: UIButton!
    @IBOutlet weak var labelMaillot: UILabel!
    @IBOutlet weak var viewMaillot: UIView!
    @IBOutlet weak var imageViewMaillot: UIImageView!
    @IBOutlet weak var labelMaillotBrand: UILabel!
    @IBOutlet weak var labelBike: UILabel!
    @IBOutlet weak var viewBike: UIView!
    @IBOutlet weak var imageViewBike: UIImageView!
    @IBOutlet weak var labelBikeBrand: UILabel!
    
    var team = Team()
    var season = ""
    var shadowBikeLayer: CAShapeLayer!
    var shadowMaillotLayer: CAShapeLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        viewMaillot.layer.cornerRadius = 5
//        viewBike.layer.cornerRadius = 5
//
//        shadowBikeLayer = CAShapeLayer()
//        shadowBikeLayer.path = UIBezierPath(roundedRect: viewBike.bounds, cornerRadius: 12).cgPath
//        shadowBikeLayer.fillColor = UIColor.white.cgColor
//        shadowBikeLayer.shadowColor = UIColor.darkGray.cgColor
//        shadowBikeLayer.shadowPath = shadowBikeLayer.path
//        shadowBikeLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//        shadowBikeLayer.shadowOpacity = 0.8
//        shadowBikeLayer.shadowRadius = 2
//        viewBike.layer.insertSublayer(shadowBikeLayer, at: 0)
        
        
//        shadowMaillotLayer = CAShapeLayer()
//        shadowMaillotLayer.path = UIBezierPath(roundedRect: viewMaillot.bounds, cornerRadius: 12).cgPath
//        shadowMaillotLayer.fillColor = UIColor.white.cgColor
//
//        shadowMaillotLayer.shadowColor = UIColor.darkGray.cgColor
//        shadowMaillotLayer.shadowPath = shadowMaillotLayer.path
//        shadowMaillotLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//        shadowMaillotLayer.shadowOpacity = 0.8
//        shadowMaillotLayer.shadowRadius = 2
//        viewMaillot.layer.insertSublayer(shadowMaillotLayer, at: 0)
        
        viewMaillot.layer.cornerRadius = 8
        viewMaillot.layer.shadowColor = UIColor.lightGray.cgColor
        viewMaillot.layer.shadowOffset = .zero
        viewMaillot.layer.shadowOpacity = 0.6
        viewMaillot.layer.shadowRadius = 2
        
        viewBike.layer.cornerRadius = 8
        viewBike.layer.shadowColor = UIColor.lightGray.cgColor
        viewBike.layer.shadowOffset = .zero
        viewBike.layer.shadowOpacity = 0.6
        viewBike.layer.shadowRadius = 2
        
    }
    
    @IBAction func buttonBack_clicked(_ sender: Any) {
        self.navigationController! .popViewController(animated: true)
    }
}
