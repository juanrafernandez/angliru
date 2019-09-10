//
//  ClassificationPresenter.swift
//  Angliru
//
//  Created by Juanra Fernández on 02/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import Foundation

protocol ClassificationPresenterInput {
    func getClassificationByType(raceName: String, season: String, type: String)
    func getTeamRidersByRace(season: String, teamName: String, raceName: String)
}

protocol ClassificationPresenterOutput {
    func presenterDidReceiveClassificationByType(classification: Array<Classification>, type: String)
    func presenterDidReceiveClassificationByTypeError(error:Error)
    func presenterDidReceiveTeamRidersByRace(result: Array<Classification>)
    func presenterDidReceiveTeamRidersByRaceError(error: Error)
}

class ClassificationPresenter: NSObject, ClassificationPresenterInput {

    var output : ClassificationPresenterOutput!
    let dataManager : ClassificationDataManager!
    
    override init () {
        dataManager = ClassificationDataManager()
    }
    
    func getClassificationByType(raceName: String, season: String, type: String) {
        dataManager.getClassificationByType(raceName: raceName, season: season,type: type, success: { (result:Array<Classification>) in
            self.output.presenterDidReceiveClassificationByType(classification: result, type: type)
        }) { (err:Error) in
            self.output.presenterDidReceiveClassificationByTypeError(error: err)
        }
    }

    func getTeamRidersByRace(season: String, teamName: String, raceName: String) {
        dataManager.getTeamRidersByRace(season: season, teamName: teamName, raceName: raceName, success: { (result) in
            self.output.presenterDidReceiveTeamRidersByRace(result: result)
        }) { (error) in
            self.output.presenterDidReceiveTeamRidersByRaceError(error: error)
        }
    }
}
