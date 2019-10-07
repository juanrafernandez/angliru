//
//  BetsDataManager.swift
//  Angliru
//
//  Created by Juanra Fernández on 10/09/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import Foundation

class BetsDataManager: NSObject {
    let betsService : BetsService!
    let betsStore : BetsStore!
    
    override init() {
        betsService = BetsService()
        betsStore = BetsStore()
    }
    
    func getBetsOpen(season:String, raceName:String, success successBlock: @escaping ((Bool) -> Void), failure failureBlock: @escaping ((Error) -> Void)){
        
        betsService.getBetsOpen(season: season, raceName: raceName, success: { (result) in
            successBlock(result)
        }) { (error) in
            failureBlock(error)
        }
    }
    
    func saveBet(raceName: String, riderName: String, season: String, typeBet: String, success successBlock: @escaping (() -> Void), failure failureBlock: @escaping ((Error) -> Void)){
        
        betsService.saveBet(raceName: raceName, riderName: riderName, season: season, typeBet: typeBet, success: {
            successBlock()
        }) { (error) in
            failureBlock(error)
        }
    }
}
