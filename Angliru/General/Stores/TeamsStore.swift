//
//  TeamsStore.swift
//  Angliru
//
//  Created by Juanra Fernández on 06/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import Foundation

class TeamsStore: BaseRealmStore {
    
    func saveTeam(team: TeamJDO) {
        try! realm.write {
            realm.create(TeamJDO.self, value: team, update: true)
        }
    }
    
    func saveTeams(teams: Array<Team>, category: String, season: String) {
        
        for team in teams {
            let teamJDO = TeamJDO()
            teamJDO.name = team.name
            teamJDO.bikeBrand = team.bikeBrand
            teamJDO.bikeImage = team.bikeImage
            teamJDO.category = category
            teamJDO.country = team.country
            teamJDO.maillotBrand = team.maillotBrand
            teamJDO.maillotImage = team.maillotImage
            teamJDO.managerName = team.managerName
            teamJDO.nameAbreviation = team.nameAbreviation
            teamJDO.officialWeb = team.officialWeb
            teamJDO.teamImage = team.teamImage
            teamJDO.twitter = team.twitter
            teamJDO.season = season
            saveTeam(team: teamJDO)
        }
    }
    
    func getTeams(season : String, category: String)->Array<Team> {
        var result = Array<Team>()
        
        let resultsRLM = realm.objects(TeamJDO.self).filter{$0.category == category && $0.season == season}    
        for teamJDO in resultsRLM {
            var team = Team()
            team.name = teamJDO.name
            team.bikeBrand = teamJDO.bikeBrand
            team.bikeImage = teamJDO.bikeImage
            team.category = teamJDO.category
            team.country = teamJDO.country
            team.maillotBrand = teamJDO.maillotBrand
            team.maillotImage = teamJDO.maillotImage
            team.managerName = teamJDO.managerName
            team.nameAbreviation = teamJDO.nameAbreviation
            team.officialWeb = teamJDO.officialWeb
            team.teamImage = teamJDO.teamImage
            team.twitter = teamJDO.twitter
            result.append(team)
        }
        return result
    }
}
