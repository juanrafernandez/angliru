//
//  TeamsDataManager.swift
//  Angliru
//
//  Created by Juanra Fernández on 05/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit

class TeamsDataManager: NSObject {
    let teamsService : TeamsService!
    let teamsStore : TeamsStore!
    
    var serverSynchronized = false
    
    override init() {
        teamsService = TeamsService()
        teamsStore = TeamsStore()
    }
    
    func getTeams(season: String, category: String,success successBlock: @escaping ((Array<Team>) -> Void), failure failureBlock: @escaping ((Error) -> Void)){
        if serverSynchronized == true {
            successBlock(teamsStore.getTeams(season: season, category: category))
        } else {
            teamsService.getTeams(season: season, category: category, success: { (result : Array<Team>) in
                self.teamsStore.saveTeams(teams: result, category: category, season: season)
                successBlock(result)
            }) { (err: Error) in
                failureBlock(err)
            }
        }
    }
    
    func getTeamRiders(season: String, team: Team,success successBlock: @escaping ((Array<Rider>) -> Void), failure failureBlock: @escaping ((Error) -> Void)){
        
        teamsService.getTeamRiders(season: season, team: team, success: { (result : Array<Rider>) in
            successBlock(result)
        }) { (err: Error) in
            failureBlock(err)
        }
    }
}
