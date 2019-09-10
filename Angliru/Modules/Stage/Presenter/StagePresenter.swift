//
//  StagePresenter.swift
//  Angliru
//
//  Created by Juanra Fernández on 02/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit

protocol StagePresenterInput {
    func getStageInfo(raceName: String , stageName: String, season: String)
    func downloadProfileImage(imageUrl:String)
}

protocol StagePresenterOutput {
    func presenterDidReceiveStageInfo(info:Stage)
    func presenterDidReceiveStageInfoError(error:Error)
    func presenterDidDownloadProfileImage(image: UIImage)
    func presenterDidDownloadProfileImageError(error: Error)
}

class StagePresenter: NSObject, StagePresenterInput {

    var output : StagePresenterOutput!
    var dataManager : StageDataManager!
    
    override init () {
        dataManager = StageDataManager()
    }
    
    func getStageInfo(raceName: String , stageName: String, season: String) {
        dataManager.getStageInfo(raceName: raceName, stageName: stageName, season: season, success: { (result) in
            if (self.output != nil) {
                self.output.presenterDidReceiveStageInfo(info: result)
            }
        }) { (err) in
            if (self.output != nil) {
                self.output.presenterDidReceiveStageInfoError(error: err)
            }
        }
    }
    
    func downloadProfileImage(imageUrl:String) {
        dataManager.downloadProfileImage(imageUrl: imageUrl, success: { (image: UIImage) in
            self.output.presenterDidDownloadProfileImage(image: image)
        }) { (err: Error) in
            self.output.presenterDidDownloadProfileImageError(error: err)
        }
    }
}
