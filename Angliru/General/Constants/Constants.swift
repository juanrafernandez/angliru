//
//  Constants.swift
//  Angliru
//
//  Created by Juanra Fernández on 31/07/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import Foundation
import UIKit

let MONTHS = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
let MONTHS_SHORT = ["ENE", "FEB", "MAR", "ABR", "MAY", "JUN", "JUL", "AGO", "SEP", "OCT", "NOV", "DIC"]
let CATEGORY_WORLDTOUR = "WorldTour"
let CATEGORY_PROCONTINENTAL = "ProContinental"
let CATEGORIES = [CATEGORY_WORLDTOUR,CATEGORY_PROCONTINENTAL]
let CLASSIFICATION_GENERAL = "GC"
let CLASSIFICATION_MOUNTAIN = "KOM"
let CLASSIFICATION_POINTS = "Points"
let CLASSIFICATION_TEAMS = "Teams"
let CLASSIFICATION_YOUTH = "Youth"
let CLASSIFICATION_TYPES = [CLASSIFICATION_GENERAL,CLASSIFICATION_MOUNTAIN,CLASSIFICATION_POINTS,CLASSIFICATION_TEAMS,CLASSIFICATION_YOUTH]
let CRONO_INDIVIDUAL = "ITT"
let CRONO_EQUIPOS = "TTT"
let CURRENT_UID = "current_uid"

let LAST_UPDATE = "lastUpdate"
let LAST_UPDATE_RACES_KEY = "lastUpdateRacesKey"
let LAST_UPDATE_CALENDAR_KEY = "lastUpdateCalendarKey"
let LAST_UPDATE_RIDERS_KEY = "lastUpdateRidersKey"
let LAST_UPDATE_TEAMS_KEY = "lastUpdateTeamsKey"

let CURRENT_SEASON = "2019"
let SEASON_SELECTED = "SeasonSelected"
let MINIMUN_YEAR_BBDD = 2019

//Race status
let RACE_END = 0
let RACE_ACTIVE = 1
let RACE_INACTIVE = 2

let COLOR_GRAY = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1.0)
let COLOR_GRAY_ALPHA = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 0.6)
let COLOR_ORANGE = UIColor(red: 236/255, green: 82/255, blue: 22/255, alpha: 1.0)
let COLOR_GREEN = UIColor(red: 0/255, green: 161/255, blue: 134/255, alpha: 1.0)
