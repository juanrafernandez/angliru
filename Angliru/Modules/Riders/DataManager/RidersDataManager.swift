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
    
    var serverSynchronized = false
    
    override init() {
        ridersService = RidersService()
        ridersStore = RidersStore()
    }
    
    func getAllRiders(category : String, season: String, success successBlock: @escaping ((Array<Rider>) -> Void), failure failureBlock: @escaping ((Error) -> Void)){
        /*if serverSynchronized == true {
            successBlock(self.ridersStore.getRiders(season: season, category: category))
        } else {
            ridersService.getAllRiders(category: category, season: season, success: { (result: Array<Rider>) in
                self.ridersStore.saveRiders(riders: result, category: category, season: season)
                successBlock(result)
            }) { (err:Error) in
                failureBlock(err)
            }
        }*/
        
        let results = self.ridersStore.getRiders(season: season, category: category)
        if results.count > 0 {
            successBlock(results)
        } else {
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
