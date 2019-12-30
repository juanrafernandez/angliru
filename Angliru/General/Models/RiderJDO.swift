//
//  RiderJDO.swift
//  Angliru
//
//  Created by Juanra Fernández on 06/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import RealmSwift

class RiderJDO : Object {
    @objc dynamic var id = ""
    @objc dynamic var season = ""
    @objc dynamic var category = ""
    @objc dynamic var name = ""
    @objc dynamic var country = ""
    @objc dynamic var birthPlace = ""
    @objc dynamic var age = ""
    @objc dynamic var dayOfBirth = ""
    @objc dynamic var monthOfBirth = ""
    @objc dynamic var yearOfBirth = ""
    @objc dynamic var height = ""
    @objc dynamic var weight = ""
    @objc dynamic var strava = ""
    @objc dynamic var twitter = ""
    @objc dynamic var photo = ""
    @objc dynamic var team = ""
    @objc dynamic var uci = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
