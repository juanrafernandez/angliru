//
//  RaceJDO.swift
//  Angliru
//
//  Created by Juanra Fernández on 06/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import RealmSwift

class RaceJDO: Object {
    @objc dynamic var season = ""
    @objc dynamic var position = -1
    @objc dynamic var name = ""
    @objc dynamic var date = ""
    @objc dynamic var dateStart = ""
    @objc dynamic var dateEnd = ""
    @objc dynamic var country = ""
    @objc dynamic var distance = 0.0
    @objc dynamic var web = ""
    @objc dynamic var twitter = ""
    @objc dynamic var facebook = ""
    @objc dynamic var altimetry = 0.0
    @objc dynamic var profileImage = ""
    @objc dynamic var destiny = ""
    @objc dynamic var origin = ""
    @objc dynamic var raceType = ""
    @objc dynamic var numTeams = ""
    var riders = List<RiderJDO>()
    var stages = List<StageJDO>()
    //var teams = List<String>()
    //var classificationTypes = List<String>()
    var racesResults = List<ResultsJDO>()
    
    override class func primaryKey() -> String? {
        return "name"
    }
}

class ResultsJDO : Object {
    @objc dynamic var classificationType = ""
    var results = List<ClassificationJDO>()
    
    convenience init (type : String, raceResults : List<ClassificationJDO>) {
        self.init()
        self.classificationType = type
        self.results = raceResults
    }
}
