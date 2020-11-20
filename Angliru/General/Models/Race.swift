//
//  Race.swift
//  Angliru
//
//  Created by Juanra Fernández on 31/07/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import Foundation

struct Race {
    var position = -1
    var name = ""
    var date = ""
    var dateStart = ""
    var dateEnd = ""
    var country = ""
    var distance = 0.0
    var web = ""
    var twitter = ""
    var facebook = ""
    var altimetry = 0.0
    var profileImage = ""
    var destiny = ""
    var origin = ""
    var raceType = ""
    var numTeams = ""
    var riders = Array<Rider>()
    var stages = Array<Stage>()
    //var teams = Array<String>()
    var classificationTypes = Array<String>()
    var racesResults = Array<[Classification]>()
}
