//
//  RidersPresenter.swift
//  Angliru
//
//  Created by Juanra Fernández on 06/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import Foundation

protocol RidersPresenterInput {
    func getAllRiders(category:String, season:String, cache: Bool)
    func getRiderInfo(riderName: String)
}

protocol RidersPresenterOutput {
    func presenterDidGetRiderInfo(rider:Rider)
    func presenterDidGetRiderInfoError(error:Error)
    func presenterDidGetAllRiders(result:Array<Rider>,category:String)
    func presenterDidGetAllRidersError(error:Error)
    func presenterDidCheckRidersUpdates(updated: String)
    func presenterDidCheckRidersUpdatesError(error: Error)
}

class RidersPresenter: NSObject, RidersPresenterInput {
    
    var dataManager : RidersDataManager!
    var output : RidersPresenterOutput!
    
    override init() {
        dataManager = RidersDataManager()
    }
    
    func checkRidersUpdates(season:String) {
        dataManager.checkRidersUpdates(season: season, success: { (result) in
            if (self.output != nil) {
                self.output.presenterDidCheckRidersUpdates(updated: result)
            }
        }) { (error) in
            self.output.presenterDidCheckRidersUpdatesError(error: error)
        }
    }
    
    func getAllRiders(category:String, season:String, cache: Bool) {
        dataManager.getAllRiders(category: category, season: season, cache: cache, success: { (result: Array<Rider>) in
            self.output.presenterDidGetAllRiders(result: result, category: category)
        }) { (err:Error) in
            self.output.presenterDidGetAllRidersError(error: err)
        }
    }
    
    func getRiderInfo(riderName: String) {
        dataManager.getRiderInfo(riderName: riderName, success: { (rider:Rider) in
            self.output.presenterDidGetRiderInfo(rider: rider)
        }) { (err:Error) in
            self.output.presenterDidGetRiderInfoError(error: err)
        }
    }
}
