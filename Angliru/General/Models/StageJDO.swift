//
//  StageJDO.swift
//  Angliru
//
//  Created by Juanra Fernández on 06/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import RealmSwift

class StageJDO: Object {
    @objc dynamic var name = ""
    @objc dynamic var type = ""
    @objc dynamic var month = ""
    @objc dynamic var day = ""
    @objc dynamic var year = ""
    @objc dynamic var date = ""
    @objc dynamic var destiny = ""
    @objc dynamic var distance = ""
    @objc dynamic var origin = ""
    @objc dynamic var position = -1
    @objc dynamic var altimetry = ""
    var result = List<ClassificationJDO>()
    @objc dynamic var profileImage = ""
    
    override class func primaryKey() -> String? {
        return "name"
    }
}
