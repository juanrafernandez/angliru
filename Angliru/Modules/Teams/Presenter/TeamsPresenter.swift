//
//  TeamsPresenter.swift
//  Angliru
//
//  Created by Juanra Fernández on 05/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit

protocol TeamsPresenterInput {
    func getTeams(season: String, category: String)
}

protocol TeamsPresenterOutput {
    func presenterDidGetTeams(result:Array<Team>,category:String)
    func presenterDidGetTeamsError(error:Error)
    func presenterDidReceiveTeamRiders(result : Array<Rider>)
    func presenterDidReceiveTeamRidersError(error : Error)
}

class TeamsPresenter: NSObject, TeamsPresenterInput {
    var output : TeamsPresenterOutput!
    var dataManager : TeamsDataManager!
    
    override init() {
        dataManager = TeamsDataManager()
    }
    
    func getTeams(season: String, category: String) {
        dataManager.getTeams(season: season, category: category, success: { (result: Array<Team>) in
            self.output.presenterDidGetTeams(result: result,category: category)
        }) { (err: Error) in
            self.output.presenterDidGetTeamsError(error: err)
        }
    }
    
    func getTeamRiders(season: String, team: Team) {
        dataManager.getTeamRiders(season: season, team: team, success: { (result:Array<Rider>) in
            self.output.presenterDidReceiveTeamRiders(result: result)
        }) { (err:Error) in
            self.output.presenterDidReceiveTeamRidersError(error: err)
        }
    }
}
