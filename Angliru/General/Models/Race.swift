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
    var altimetry = 0.0
    var profileImage = ""
    var stages = Array<String>()
    var teams = Array<String>()
    var classificationTypes = Array<String>()
    var racesResults = Array<[Classification]>()
    
}
