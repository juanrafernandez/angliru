//
//  Utils.swift
//  Angliru
//
//  Created by Juanra Fernández on 01/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import Foundation
import UIKit

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
    
    static func getNumberOfLinesInLabel(label: UILabel, text: String) -> Int {
        let maxSize = CGSize(width: label.frame.size.width, height: CGFloat(MAXFLOAT))
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: label.font!], context: nil).height
        let lineHeight = label.font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
    
    static func launchSafari(decodedURL: String) {
        
        var stringURL = decodedURL
        if !stringURL.contains("http:") {
            stringURL = String.init(format: "%@%@", "http://", decodedURL)
        }
        
        guard let url2 = URL(string: stringURL) else { return }
        UIApplication.shared.open(url2)
    }
}
