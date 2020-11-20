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
    
    static func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: Date())
        //let dateString = formatter.date(from: myString)
        //formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        return dateString
    }
    
    static func getCurrentYear () -> String {
        let date = Date()
        let calendar = Calendar.current
        return String(calendar.component(.year, from: date))
    }
    
    static func getDateFrom(stringDate:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.date(from: stringDate)!
    }
    
    static func getKeyword (word: String) -> String {
        return word.lowercased().components(separatedBy: .whitespacesAndNewlines).joined().folding(options: .diacriticInsensitive, locale: .current)
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
    
    static func getRaceStatus(raceDayStart: String, raceMonthStart: String, raceDayEnd: String, raceMonthEnd: String) -> Int {
        let currentYear = Int(UserDefaults.standard.string(forKey: SEASON_SELECTED) ?? "2019")
        let dateStartFormatted = Utils.makeDate(year: currentYear!, month: Int(raceMonthStart)!, day: Int(raceDayStart)!)
        var dateEndFormatted = Date()
        if raceDayEnd == "" || raceMonthEnd == "" {
            dateEndFormatted = dateStartFormatted
        } else {
            dateEndFormatted = Utils.makeDate(year: currentYear!, month: Int(raceMonthEnd)!, day: Int(raceDayEnd)!)
        }
        
        let currentDate = Date()
        
        if dateEndFormatted > currentDate {
            return RACE_INACTIVE
        } else if dateStartFormatted >= currentDate && dateEndFormatted <= currentDate{
            return RACE_ACTIVE
        } else {
            return RACE_END
        }
    }
    
    static func makeDate(year: Int, month: Int, day: Int) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        // calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let components = DateComponents(year: year, month: month, day: day)
        return calendar.date(from: components)!
    }
}
