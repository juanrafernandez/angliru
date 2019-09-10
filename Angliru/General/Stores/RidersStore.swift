//
//  RidersStore.swift
//  Angliru
//
//  Created by Juanra Fernández on 06/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import Foundation

class RidersStore: BaseRealmStore {
    
    func saveRider(rider: RiderJDO) {
        try! realm.write {
            realm.create(RiderJDO.self, value: rider, update: true)
        }
    }
    
    func saveRiders(riders: Array<Rider>, category: String, season: String) {
        
        for rider in riders {
            let riderJDO = RiderJDO()
            riderJDO.name = rider.name
            riderJDO.age = rider.age
            riderJDO.birthPlace = rider.birthPlace
            riderJDO.category = rider.category
            riderJDO.season = season
            riderJDO.country = rider.country
            riderJDO.dayOfBirth = rider.dayOfBirth
            riderJDO.height = rider.height
            riderJDO.monthOfBirth = rider.monthOfBirth
            riderJDO.photo = rider.photo
            riderJDO.strava = rider.strava
            riderJDO.team = rider.team
            riderJDO.twitter = rider.twitter
            riderJDO.uci = rider.uci
            riderJDO.weight = rider.weight
            riderJDO.yearOfBirth = rider.yearOfBirth
            saveRider(rider: riderJDO)
        }
    }
    
    func getRiders(season : String, category: String)->Array<Rider> {
        var result = Array<Rider>()
        
        let resultsRLM = realm.objects(RiderJDO.self).filter{$0.category == category && $0.season == season}
        for riderJDO in resultsRLM {
            var rider = Rider()
            rider.name = riderJDO.name
            rider.age = riderJDO.age
            rider.birthPlace = riderJDO.birthPlace
            rider.category = riderJDO.category
            rider.country = riderJDO.country
            rider.dayOfBirth = riderJDO.dayOfBirth
            rider.height = riderJDO.height
            rider.monthOfBirth = riderJDO.monthOfBirth
            rider.photo = riderJDO.photo
            rider.strava = riderJDO.strava
            rider.team = riderJDO.team
            rider.twitter = riderJDO.twitter
            rider.uci = riderJDO.uci
            rider.weight = riderJDO.weight
            rider.yearOfBirth = riderJDO.yearOfBirth
            result.append(rider)
        }
        return result
    }
}
