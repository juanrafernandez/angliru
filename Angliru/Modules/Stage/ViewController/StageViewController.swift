//
//  StageViewController.swift
//  Angliru
//
//  Created by Juanra Fernández on 02/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit
import SVProgressHUD

class StageViewController: UIViewController, StagePresenterOutput {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDateTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelOriginTitle: UILabel!
    @IBOutlet weak var labelOrigin: UILabel!
    @IBOutlet weak var labelDestinyTitle: UILabel!
    @IBOutlet weak var labelDestiny: UILabel!
    @IBOutlet weak var labelDistanceTitle: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelAltimetryTitle: UILabel!
    @IBOutlet weak var labelAltimetry: UILabel!
    @IBOutlet weak var buttonClassification: UIButton!
    @IBOutlet weak var labelProfile: UILabel!
    @IBOutlet weak var imageViewProfile: UIImageView!
    var raceName = ""
    var stageName = ""
    var season = ""
    var presenter = StagePresenter()
    var stage = Stage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        presenter.output = self
        //presenter.getStageInfo(raceName: raceName, stageName: stageName, season: season)
        initializeInterface ()
    }
    
    func initializeInterface () {
        labelTitle.text = stageName
        labelDate.text = stage.date
        labelOrigin.text = stage.origin
        labelDestiny.text = stage.destiny
        labelDistance.text = stage.distance
        labelAltimetry.text = stage.altimetry
        if stage.profileImage != "" {
            presenter.downloadProfileImage(imageUrl: stage.profileImage)
        }
    }
    
    @IBAction func buttonBack_clicked(_ sender: Any) {
        self.navigationController! .popViewController(animated: true)
    }
    
    @IBAction func buttonClassification_clicked(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ClassificationViewController") as! ClassificationViewController
        viewController.classificationTypes.append(CLASSIFICATION_GENERAL)
        viewController.racesResults.append(stage.result)
        viewController.season = "2019"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: StagePresenterOutput methods
    func presenterDidReceiveStageInfo(info:Stage) {
        stage = info
        initializeInterface ()
        SVProgressHUD.dismiss()
    }
    
    func presenterDidReceiveStageInfoError(error:Error) {
        SVProgressHUD.dismiss()
    }
    
    func presenterDidDownloadProfileImage(image: UIImage) {
        imageViewProfile.image = image
        SVProgressHUD.dismiss()
    }
    
    func presenterDidDownloadProfileImageError(error: Error) {
        SVProgressHUD.dismiss()
    }
}
