//
//  Classification.swift
//  Angliru
//
//  Created by Juanra Fernández on 01/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import Foundation

struct Classification {
    var name = ""
    var age = ""
    var country = ""
    var team = ""
    var teamAbreviation = ""
    var time = ""
    var points = ""
    var season = ""
    
    init() {
        
    }
    
    init(name: String, age: String, country: String, team: String, time: String, points: String ) {
        self.name = name
        self.age = age
        self.country = country
        self.team = team
        self.time = time
        self.points = points
    }
}
