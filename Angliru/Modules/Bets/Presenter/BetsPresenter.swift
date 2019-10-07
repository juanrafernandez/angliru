//
//  BetsPresenter.swift
//  Angliru
//
//  Created by Juanra Fernández on 10/09/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import Foundation

protocol BetsPresenterInput {
    func saveBet(raceName: String, riderName: String, season:String, typeBet: String)
    func getBetsOpen(season:String, raceName:String)
}

protocol BetsPresenterOutput {
    func presenterDidSaveBet()
    func presenterDidSaveBetError(error:Error)
    func presenterGetBetsOpen(result: Bool)
    func presenterGetBetsOpenError(error: Error)
}

class BetsPresenter: NSObject, BetsPresenterInput {
    
    var output : BetsPresenterOutput!
    var dataManager : BetsDataManager!
    
    override init() {
        dataManager = BetsDataManager()
    }
    
    func saveBet(raceName: String, riderName: String, season: String, typeBet: String) {
        dataManager.saveBet(raceName: raceName, riderName: riderName, season: season, typeBet: typeBet ,success: {
            self.output.presenterDidSaveBet()
        }) { (error) in
            self.output.presenterDidSaveBetError(error: error)
        }
    }
    
    func getBetsOpen(season:String, raceName:String) {
        dataManager.getBetsOpen(season: season, raceName: raceName, success: { (result) in
            self.output.presenterGetBetsOpen(result: result)
        }) { (error) in
            self.output.presenterGetBetsOpenError(error: error)
        }
    }
}
