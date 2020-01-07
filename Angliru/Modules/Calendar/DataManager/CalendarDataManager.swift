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
    
    var serverSynchronized = false
    
    override init() {
        raceService = RacesService()
        raceStore = RacesStore()
    }
    
    func getCalendarRaces(season: String, success successBlock: @escaping ((Array<Race>) -> Void), failure failureBlock: @escaping ((Error) -> Void)) {
       /* if serverSynchronized == true {
            successBlock(self.raceStore.getRaces(season: season))
        } else {
            raceService.getCalendarInfo(season: season, success: { (result : Array<Race>) in
                self.raceStore.saveRaces(races: result, season: season)
                successBlock(result)
            }) { (err : Error) in
                failureBlock(err)
            }
        } */
        
//        let results = self.raceStore.getRaces(season: season)
//        if results.count > 0 {
//            successBlock(results)
//        } else {
            raceService.getCalendarInfo(season: season, success: { (result : Array<Race>) in
                self.raceStore.saveRaces(races: result, season: season)
                successBlock(result)
            }) { (err : Error) in
                failureBlock(err)
            }
        //}
    }
}
