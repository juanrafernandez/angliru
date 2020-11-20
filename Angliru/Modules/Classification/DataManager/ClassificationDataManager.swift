//
//  ClassificationDataManager.swift
//  Angliru
//
//  Created by Juanra Fernández on 02/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit

class ClassificationDataManager: NSObject {
    let racesService : RacesService!
    let racesStore : RacesStore!
    
    var serverSynchronized = false
    
    override init() {
        racesService = RacesService()
        racesStore = RacesStore()
    }
    
    func checkClassificationRacesUpdates(season:String, success successBlock: @escaping ((String) -> Void), failure failureBlock: @escaping ((Error) -> Void)) {
        
        racesService.checkClassificationRacesUpdates(season: season, success: { (result : String) in
            successBlock(result)
        }) { (error) in
            failureBlock(error)
        }
    }
    
    func getClassificationByType(raceName: String, season: String,type: String, cache: Bool, success successBlock: @escaping ((Array<Classification>) -> Void), failure failureBlock: @escaping ((Error) -> Void)){
        /*if serverSynchronized == true {
            successBlock(racesStore.getRaceClassification(raceName: raceName, season: season,type: type))
        } else { */
           
        
        var numClassificationsCache = 0
        if cache {
            let results = racesStore.getRaceClassification(raceName: raceName, season: season,type: type)
            numClassificationsCache = results.count
            if numClassificationsCache > 0 {
                successBlock(results)
            }
        }
            
        if !cache || numClassificationsCache == 0  {
            racesService.getClassificationByType(raceName: raceName, season: season ,type: type, success: { (result: Array<Classification>) in
                if result.count > 0 {
                    self.racesStore.saveRaceClassification(raceName: raceName, type: type, season: season, results: result)
                }
                successBlock(result)
            }) { (err:Error) in
                failureBlock(err)
            }
        }
        
//        let results = racesStore.getRaceClassification(raceName: raceName, season: season,type: type)
//            if results.count > 0 {
//                successBlock(results)
//            } else {
//                racesService.getClassificationByType(raceName: raceName, season: season ,type: type, success: { (result: Array<Classification>) in
//                    if result.count > 0 {
//                        self.racesStore.saveRaceClassification(raceName: raceName, type: type, season: season, results: result)
//                    }
//                    successBlock(result)
//                }) { (err:Error) in
//                    failureBlock(err)
//                }
//            }
    }
    
    func getTeamRidersByRace(season: String, teamName: String, raceName: String, success successBlock: @escaping ((Array<Classification>) -> Void), failure failureBlock: @escaping ((Error) -> Void)) {
        let results = racesStore.getRaceTeamsRiders(season: season, raceName: raceName, teamName: teamName)
        if results.count > 0 {
            successBlock(results)
        } else {
            racesService.getTeamRidersByRace(season: season, teamName: teamName, raceName: raceName, success: { (result) in
                // TODO -> Arreglar - en caché se guardan clasificaciones completas -
                /*if result.count > 0 {
                    self.racesStore.saveRaceClassification(raceName: raceName, type: "GC", season: season, results: result)
                }*/
                
                successBlock(result)
            }) { (error) in
                failureBlock(error)
            }
            
        }
    }
    
}
