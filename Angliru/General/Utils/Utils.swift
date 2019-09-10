//
//  Utils.swift
//  Angliru
//
//  Created by Juanra Fernández on 01/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import Foundation

class Utils {
    
    static func getCurrentYear () -> String {
        let date = Date()
        let calendar = Calendar.current
        return String(calendar.component(.year, from: date))
    }
    
    static func removeEmptyFields (documentData : Dictionary<String, String>) -> Dictionary<String, String>{
        return documentData.filter { $0.value != ""}.mapValues { $0 }
    }
    
    static func removeEmptyAnyFields (documentData : Dictionary<String, Any>) -> Dictionary<String, Any>{
        return documentData.filter { $0.value as? String != ""}.mapValues { $0 }
    }
}
