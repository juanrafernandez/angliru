//
//  RidersDataManager.swift
//  Angliru
//
//  Created by Juanra Fernández on 06/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import Foundation

class RidersDataManager: NSObject {
    let ridersService : RidersService!
    let ridersStore : RidersStore!
    
    override init() {
        ridersService = RidersService()
        ridersStore = RidersStore()
    }
    
    func checkRidersUpdates(season:String, success successBlock: @escaping ((String) -> Void), failure failureBlock: @escaping ((Error) -> Void)) {
        ridersService.checkRidersUpdates(season: season, success: { (result) in
            successBlock(result)
        }) { (error) in
            failureBlock(error)
        }
    }
    
    func getAllRiders(category : String, season: String, cache: Bool ,success successBlock: @escaping ((Array<Rider>) -> Void), failure failureBlock: @escaping ((Error) -> Void)){
        
        var numRidersCache = 0
        if cache {
            let results = self.ridersStore.getRiders(season: season, category: category)
            numRidersCache = results.count
            if numRidersCache > 0 {
                successBlock(results)
            }
        }
            
        if !cache || numRidersCache == 0  {
            ridersService.getAllRiders(category: category, season: season, success: { (result: Array<Rider>) in
                self.ridersStore.saveRiders(riders: result, category: category, season: season)
                successBlock(result)
            }) { (err:Error) in
                failureBlock(err)
            }
        }
    }
    
    func getRiderInfo(riderName : String, success successBlock: @escaping ((Rider) -> Void), failure failureBlock: @escaping ((Error) -> Void)){
        ridersService.getRiderInfo(riderName: riderName, success: { (rider : Rider) in
            successBlock(rider)
        }) { (err: Error) in
            failureBlock(err)
        }
    }
}
