//
//  ClassificationJDO.swift
//  Angliru
//
//  Created by Juanra Fernández on 06/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import RealmSwift

class ClassificationJDO : Object {
    @objc dynamic var name = ""
    @objc dynamic var age = ""
    @objc dynamic var country = ""
    @objc dynamic var team = ""
    @objc dynamic var teamAbreviation = ""
    @objc dynamic var time = ""
    @objc dynamic var points = ""
    @objc dynamic var season = ""
    
    /*override class func primaryKey() -> String? {
        return "name"
    }*/
}
