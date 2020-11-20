//
//  CalendarDataManager.swift
//  Angliru
//
//  Created by Juanra Fernández on 01/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import Foundation
import UIKit

class CalendarDataManager: NSObject {
    let raceService : RacesService!
    let raceStore : RacesStore!
    
    override init() {
        raceService = RacesService()
        raceStore = RacesStore()
    }
    
    func checkCalendarRacesUpdates(season:String, success successBlock: @escaping ((String) -> Void), failure failureBlock: @escaping ((Error) -> Void)) {
        
        raceService.checkCalendarRacesUpdates(season: season, success: { (result : String) in
            successBlock(result)
        }) { (error) in
            failureBlock(error)
        }
    }
    
    func getCalendarRaces(season: String, cache: Bool, success successBlock: @escaping ((Array<Race>) -> Void), failure failureBlock: @escaping ((Error) -> Void)) {
       
        var numRacesCache = 0
        if cache {
            let results = self.raceStore.getRaces(season: season)
            numRacesCache = results.count
            if numRacesCache > 0 {
                successBlock(results)
            }
        }
            
        if !cache || numRacesCache == 0  {
            raceService.getCalendarInfo(season: season, success: { (result : Array<Race>) in
                self.raceStore.saveRaces(races: result, season: season)
                successBlock(result)
            }) { (err : Error) in
                failureBlock(err)
            }
        }
    }
}
