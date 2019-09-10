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
    
    var serverSynchronized = true
    
    override init() {
        racesService = RacesService()
        racesStore = RacesStore()
    }
    
    func getClassificationByType(raceName: String, season: String,type: String, success successBlock: @escaping ((Array<Classification>) -> Void), failure failureBlock: @escaping ((Error) -> Void)){
        /*if serverSynchronized == true {
            successBlock(racesStore.getRaceClassification(raceName: raceName, season: season,type: type))
        } else { */
            
        let results = racesStore.getRaceClassification(raceName: raceName, season: season,type: type)
            if results.count > 0 {
                successBlock(results)
            } else {
                racesService.getClassificationByType(raceName: raceName, season: season ,type: type, success: { (result: Array<Classification>) in
                    if result.count > 0 {
                        self.racesStore.saveRaceClassification(raceName: raceName, type: type, season: season, results: result)
                    }
                    successBlock(result)
                }) { (err:Error) in
                    failureBlock(err)
                }
            }
    }
    
    func getTeamRidersByRace(season: String, teamName: String, raceName: String, success successBlock: @escaping ((Array<Classification>) -> Void), failure failureBlock: @escaping ((Error) -> Void)) {
        successBlock(racesStore.getRaceTeamsRiders(season: season, raceName: raceName, teamName: teamName))
    }
    
}
