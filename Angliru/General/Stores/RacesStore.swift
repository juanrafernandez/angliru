    //
//  RacesStore.swift
//  Angliru
//
//  Created by Juanra Fernández on 07/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import Foundation
    
class RacesStore: BaseRealmStore {
    
    func saveRace(race: RaceJDO) {
        try! realm.write {
            realm.create(RaceJDO.self, value: race, update: true)
        }
    }
    
    func saveRaces(races: Array<Race>, season: String) {
        
        for race in races {
            let raceJDO = RaceJDO()
            raceJDO.season = season
            raceJDO.position = (race.position == -1) ? raceJDO.position : race.position
            raceJDO.name = race.name.isEmpty ? raceJDO.name : race.name
            raceJDO.date = race.date.isEmpty ? raceJDO.date : race.date
            raceJDO.dateStart = race.dateStart.isEmpty ? raceJDO.dateStart : race.dateStart
            raceJDO.dateEnd = race.dateEnd.isEmpty ? raceJDO.dateEnd : race.dateEnd
            raceJDO.country = race.country.isEmpty ? raceJDO.country : race.country
            raceJDO.distance = (race.distance == -1) ? raceJDO.distance : race.distance
            raceJDO.web = race.web.isEmpty ? raceJDO.web : race.web
            raceJDO.twitter = race.twitter.isEmpty ? raceJDO.twitter : race.twitter
            raceJDO.facebook = race.facebook.isEmpty ? raceJDO.facebook : race.facebook
            raceJDO.altimetry = (race.altimetry == -1) ? raceJDO.altimetry : race.altimetry
            raceJDO.profileImage = race.profileImage.isEmpty ? raceJDO.profileImage : race.profileImage
            raceJDO.raceType = race.raceType.isEmpty ? raceJDO.raceType : race.raceType
            raceJDO.numTeams = race.numTeams.isEmpty ? raceJDO.numTeams : race.numTeams
            raceJDO.origin = race.origin.isEmpty ? raceJDO.origin : race.origin
            raceJDO.destiny = race.destiny.isEmpty ? raceJDO.destiny : race.destiny
            
            for stage in race.stages {
                let stageJDO = StageJDO()
                stageJDO.altimetry = stage.altimetry
                stageJDO.date = stage.date
                stageJDO.day = stage.day
                stageJDO.destiny = stage.destiny
                stageJDO.distance = stage.distance
                stageJDO.month = stage.month
                stageJDO.name = stage.name
                stageJDO.origin = stage.origin
                stageJDO.position = stage.position
                stageJDO.profileImage = stage.profileImage
                stageJDO.type = stage.type
                stageJDO.year = stage.year
                //TODO-> Metodo para guardar los resultados de cada etapa
                for result in stage.result {
                    let classificationJDO = ClassificationJDO()
                    classificationJDO.name = result.name
                    classificationJDO.age = result.age
                    classificationJDO.country = result.country
                    classificationJDO.team = result.team
                    classificationJDO.teamAbreviation = result.teamAbreviation
                    classificationJDO.time = result.time
                    classificationJDO.points = result.points
                    classificationJDO.season = stage.year
                    stageJDO.result.append(classificationJDO)
                }
                //stageJDO.result = saveStageClassification()
                raceJDO.stages.append(stageJDO)
            }
//            for team in race.teams {
//                raceJDO.teams.append(team)
//            }
           
            saveRace(race: raceJDO)
        }
    }
    
    func saveRaceTeams(raceName:String, season: String, teams:Array<RiderJDO>) {
        let resultsRLM = realm.objects(RaceJDO.self).filter{$0.name == raceName && $0.season == season}
        let race = resultsRLM.first
        try! realm.write {
            
            race?.riders.removeAll()
            for rider in teams {
                //race?.riders.append(rider)
                
                let riderJDO = RiderJDO()
                riderJDO.name = rider.name
                riderJDO.team = rider.team
                riderJDO.age = rider.age
                riderJDO.birthPlace = rider.birthPlace
                riderJDO.category = rider.category
                riderJDO.country = rider.country
                riderJDO.dayOfBirth = rider.dayOfBirth
                riderJDO.height = rider.height
                riderJDO.monthOfBirth = rider.monthOfBirth
                riderJDO.photo = rider.photo
                riderJDO.season = rider.season
                riderJDO.strava = rider.strava
                riderJDO.twitter = rider.twitter
                riderJDO.uci = rider.uci
                riderJDO.weight = rider.weight
                riderJDO.yearOfBirth = rider.yearOfBirth
                race?.riders.append(riderJDO)
            }
            realm.create(RaceJDO.self, value: race!, update: true)
        }
    }
    
    //func saveStageClassification(
    func saveRaceClassification(raceName:String, type: String, season : String, results: Array<Classification>) {
        let resultsRLM = realm.objects(RaceJDO.self).filter{$0.name == raceName && $0.season == season}
        let race = resultsRLM.first
        
        try! realm.write {
            let resultJDO = ResultsJDO()
            resultJDO.classificationType = type
            
            var removeResultsJDO = ResultsJDO()
            for resultSaved in race!.racesResults {
                if resultSaved.classificationType == type {
                    removeResultsJDO = resultSaved
                    break
                }
            }
            if removeResultsJDO.classificationType != "" {
                realm.delete(removeResultsJDO)
            }
            
            for classification in results {
                let classificationJDO = ClassificationJDO()
                classificationJDO.season = season
                classificationJDO.name = classification.name
                classificationJDO.age = classification.age
                classificationJDO.country = classification.country
                classificationJDO.team = classification.team
                classificationJDO.teamAbreviation = classification.teamAbreviation
                classificationJDO.time = classification.time
                classificationJDO.points = classification.points
                resultJDO.results.append(classificationJDO)
            }
            
            race?.racesResults.append(resultJDO)
            realm.create(RaceJDO.self, value: race!, update: true)
        }
    }
    
    func saveStageClassification(raceName:String, type: String, season : String, results: Array<Classification>) {
        let resultsRLM = realm.objects(RaceJDO.self).filter{$0.name == raceName && $0.season == season}
        let race = resultsRLM.first
        
        try! realm.write {
            let resultJDO = ResultsJDO()
            resultJDO.classificationType = type
            
            var removeResultsJDO = ResultsJDO()
            for resultSaved in race!.racesResults {
                if resultSaved.classificationType == type {
                    removeResultsJDO = resultSaved
                    break
                }
            }
            if removeResultsJDO.classificationType != "" {
                realm.delete(removeResultsJDO)
            }
            
            for classification in results {
                let classificationJDO = ClassificationJDO()
                classificationJDO.season = season
                classificationJDO.name = classification.name
                classificationJDO.age = classification.age
                classificationJDO.country = classification.country
                classificationJDO.team = classification.team
                classificationJDO.teamAbreviation = classification.teamAbreviation
                classificationJDO.time = classification.time
                classificationJDO.points = classification.points
                resultJDO.results.append(classificationJDO)
            }
            
            race?.racesResults.append(resultJDO)
            realm.create(RaceJDO.self, value: race!, update: true)
        }
    }
    
    func getRaceClassification(raceName:String, season: String, type: String) -> Array<Classification> {
        let resultsRLM = realm.objects(RaceJDO.self).filter{$0.name == raceName && $0.season == season}
        let race = resultsRLM.first
        var result = Array<Classification>()
        if race != nil {
            for resultJDO in race!.racesResults {
                if resultJDO.classificationType == type {
                    for classificationJDO in resultJDO.results {
                        var classification = Classification()
                        classification.name = classificationJDO.name
                        classification.age = classificationJDO.age
                        classification.country = classificationJDO.country
                        classification.team = classificationJDO.team
                        classification.teamAbreviation = classificationJDO.teamAbreviation
                        classification.time = classificationJDO.time
                        classification.points = classificationJDO.points
                        result.append(classification)
                    }
                }
            }
        }
        return result
    }
    
    func getRaceTeamsRiders(season: String, raceName: String, teamName: String) ->Array<Classification>{
        var result = Array<Classification>()
        
        let resultsRLM = realm.objects(RaceJDO.self).filter{$0.name == raceName && $0.season == season}
        let race = resultsRLM.first
        
        if race != nil && race!.racesResults.count>0{
            for resultsJDO in race!.racesResults {
                if resultsJDO.classificationType == "GC" {
                    for classificationJDO in resultsJDO.results {
                        if teamName == classificationJDO.team {
                            var classification = Classification()
                            classification.name = classificationJDO.name
                            classification.age = classificationJDO.age
                            classification.country = classificationJDO.country
                            classification.team = classificationJDO.team
                            classification.teamAbreviation = classificationJDO.teamAbreviation
                            classification.time = classificationJDO.time
                            classification.points = classificationJDO.points
                            result.append(classification)
                        }
                    }
                }
            }
        }
        return result
    }
    
    func getRaceTeams(raceName:String, season: String) ->Array<RiderJDO> {
        var result = Array<RiderJDO>()
        let resultsRLM = realm.objects(RaceJDO.self).filter{$0.name == raceName && $0.season == season}
        let race = resultsRLM.first
        
        if race != nil && race!.riders.count>0{
            for riderJDO in race!.riders {
                let rider = RiderJDO()
                rider.age = riderJDO.age
                rider.birthPlace = riderJDO.birthPlace
                rider.category = riderJDO.category
                rider.country = riderJDO.country
                rider.dayOfBirth = riderJDO.dayOfBirth
                rider.height = riderJDO.height
                rider.monthOfBirth = riderJDO.monthOfBirth
                rider.name = riderJDO.name
                rider.photo = riderJDO.photo
                rider.season = riderJDO.season
                rider.strava = riderJDO.strava
                rider.team = riderJDO.team
                rider.twitter = riderJDO.twitter
                rider.uci = riderJDO.uci
                rider.weight = riderJDO.weight
                rider.yearOfBirth = riderJDO.yearOfBirth
                result.append(rider)
            }
        }
        return result
    }
    
    func getRaces(season : String)->Array<Race> {
        var result = Array<Race>()
        
        let resultsRLM = realm.objects(RaceJDO.self).filter{$0.season == season}
        for raceJDO in resultsRLM {
            var race = Race()
            race.position = raceJDO.position
            race.name = raceJDO.name
            race.date = raceJDO.date
            race.dateStart = raceJDO.dateStart
            race.dateEnd = raceJDO.dateEnd
            race.country = raceJDO.country
            race.distance = raceJDO.distance
            race.web = raceJDO.web
            race.twitter = raceJDO.twitter
            race.facebook = raceJDO.facebook
            race.altimetry = raceJDO.altimetry
            race.profileImage = raceJDO.profileImage
            race.numTeams = raceJDO.numTeams
            race.raceType = raceJDO.raceType
            race.origin = raceJDO.origin
            race.destiny = raceJDO.destiny
            
            for stageJDO in raceJDO.stages {
                var stage = Stage()
                stage.altimetry = stageJDO.altimetry
                stage.date = stageJDO.date
                stage.day = stageJDO.day
                stage.destiny = stageJDO.destiny
                stage.distance = stageJDO.distance
                stage.month = stageJDO.month
                stage.name = stageJDO.name
                stage.origin = stageJDO.origin
                stage.position = stageJDO.position
                stage.profileImage = stageJDO.profileImage
                stage.type = stageJDO.type
                stage.year = stageJDO.year
                //stageJDO.result = stage.result
                //raceJDO.stages.append(stageJDO)
                race.stages.append(stage)
            }
//            for team in raceJDO.teams {
//                race.teams.append(team)
//            }
            /*for classType in race.classificationTypes {
                var resultsJDO = ResultsJDO()
                resultsJDO.classificationType = classType
                //resultsJDO.results = race.racesResults[classType]
            }*/
            
            result.append(race)
        }
        return result
    }
}

