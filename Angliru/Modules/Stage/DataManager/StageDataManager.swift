//
//  StageDataManager.swift
//  Angliru
//
//  Created by Juanra Fernández on 02/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit

class StageDataManager: NSObject {
    let raceService : RacesService!
    
    override init() {
        raceService = RacesService()
    }
    
    func getStageInfo(raceName: String , stageName: String, season: String, success successBlock: @escaping ((Stage) -> Void), failure failureBlock: @escaping ((Error) -> Void)){
        raceService.getStageInfo(raceName: raceName, stageName: stageName, season: season, success: { (result) in
            successBlock(result)
        }) { (err) in
            failureBlock(err)
        }
    }
    
    func downloadProfileImage(imageUrl:String, success successBlock: @escaping ((UIImage) -> Void), failure failureBlock: @escaping ((Error) -> Void)) {
        raceService.downloadProfileImage(imageUrl: imageUrl, success: { (image:UIImage) in
            successBlock(image)
        }) { (err: Error) in
            failureBlock(err)
        }
    }
    
}
