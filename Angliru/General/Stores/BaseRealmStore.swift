//
//  BaseRealmStore.swift
//  Angliru
//
//  Created by Juanra Fernández on 06/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import Foundation
import RealmSwift

class BaseRealmStore : NSObject {

    let realm = try! Realm()

    func removeDataBase() {
        realm.beginWrite()
        realm.deleteAll()
        try! realm.commitWrite()
    }
}
