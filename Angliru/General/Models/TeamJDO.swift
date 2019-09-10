//
//  TeamJDO.swift
//  Angliru
//
//  Created by Juanra Fernández on 06/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import RealmSwift

class TeamJDO: Object {
    @objc dynamic var season = ""
    @objc dynamic var category = ""
    @objc dynamic var name = ""
    @objc dynamic var country = ""
    @objc dynamic var teamImage = ""
    @objc dynamic var nameAbreviation = ""
    @objc dynamic var maillotImage = ""
    @objc dynamic var maillotBrand = ""
    @objc dynamic var bikeImage = ""
    @objc dynamic var bikeBrand = ""
    @objc dynamic var officialWeb = ""
    @objc dynamic var twitter = ""
    @objc dynamic var managerName = ""
    
    override class func primaryKey() -> String? {
        return "name"
    }
}
