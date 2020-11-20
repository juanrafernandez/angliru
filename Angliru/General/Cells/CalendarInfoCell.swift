//
//  CalendarInfoCell.swift
//  Angliru
//
//  Created by Juanra Fernández on 30/12/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit

class CalendarInfoCell : UITableViewCell {
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var viewTarget: UIView!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var labelYear: UILabel!
    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var labelRaceName: UILabel!
    @IBOutlet weak var labelRaceDate: UILabel!
    @IBOutlet weak var labelRaceType: UILabel!
    @IBOutlet weak var imageViewCountry: UIImageView!
    @IBOutlet weak var labelRaceDistance: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var labelStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewTarget.layer.cornerRadius = 10
        viewShadow.layer.cornerRadius = 10
        viewStatus.layer.cornerRadius = 10
        
        
        let maskPath = UIBezierPath(roundedRect: viewDate.bounds,
                                    byRoundingCorners: [.bottomLeft, .topLeft],
                    cornerRadii: CGSize(width: 10.0, height: 10.0))

        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        
        //shape.borderWidth = 1
        //shape.borderColor = UIColor.black.cgColor
        
        //viewDate.layer.masksToBounds = true
        
        //viewDate.layer.borderWidth = 1
        //viewDate.layer.mask = shape
        
        //viewDate.layer.borderColor = UIColor.black.cgColor
        
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = shape.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.black.cgColor
        borderLayer.lineWidth = 2
        borderLayer.frame = bounds
        viewDate.layer.addSublayer(borderLayer)
        
        viewDate.layer.mask = shape
        
        
        viewShadow.layer.shadowColor = UIColor.gray.cgColor
        viewShadow.layer.shadowOpacity = 0.3
        viewShadow.layer.shadowOffset = CGSize.zero
        viewShadow.layer.shadowRadius = 6
    }
    
    public func setCellData(race: Race) {
        self.labelRaceName.text = race.name
        
        var position = race.dateStart.firstIndex(of: ".") ?? race.dateStart.endIndex
        let dateNumber = String(race.dateStart[..<position])
        position = race.dateStart.index(position, offsetBy: 1)
        let dateMonth = String(race.dateStart[position...])
        
        self.labelDay.text = dateNumber
        self.labelMonth.text = MONTHS_SHORT[Int(dateMonth)!-1]
        var dateNumberEnd = ""
        var dateMonthEnd = ""
        if race.dateEnd != "" {
            var positionEnd = race.dateEnd.firstIndex(of: ".") ?? race.dateEnd.endIndex
            dateNumberEnd = String(race.dateEnd[..<positionEnd])
            positionEnd = race.dateEnd.index(positionEnd, offsetBy: 1)
            dateMonthEnd = String(race.dateEnd[positionEnd...])
            self.labelRaceDate.text = "\(dateNumber) \(MONTHS_SHORT[Int(dateMonth)!]) - \(dateNumberEnd) \(MONTHS_SHORT[Int(dateMonthEnd)!])"
        } else {
            self.labelRaceDate.text = "\(dateNumber) \(MONTHS_SHORT[Int(dateMonth)!])"
        }
        let raceStatus = Utils.getRaceStatus(raceDayStart: dateNumber, raceMonthStart: dateMonth, raceDayEnd: dateNumberEnd, raceMonthEnd: dateMonthEnd)
        
        switch raceStatus {
        case RACE_END:
            viewDate.backgroundColor = COLOR_ORANGE
            break
        case RACE_ACTIVE:
            viewDate.backgroundColor = COLOR_GREEN
            break
        case RACE_INACTIVE:
            viewDate.backgroundColor = UIColor.white
//            viewDate.layer.borderColor = UIColor.black.cgColor
//            viewDate.layer.borderWidth = 1
            self.labelDay.textColor = .black
            self.labelYear.textColor = .black
            self.labelMonth.textColor = .black
            break
        default:
            viewDate.backgroundColor = UIColor.white
//            viewDate.layer.borderColor = UIColor.black.cgColor
//            viewDate.layer.borderWidth = 1
            break
        }
        
        if race.distance != 0 {
            self.labelRaceDistance.isHidden = false
            self.labelRaceDistance.text = "\(String(race.distance)) km"
        } else {
            self.labelRaceDistance.isHidden = true
        }
        
        if race.stages.count > 0 {
            self.labelRaceType.text = "\(race.stages.count) ETAPAS"
        } else {
            self.labelRaceType.text = "CLÁSICA"
        }
    }
    
//    func getRaceStatus(raceDayStart: String, raceMonthStart: String, raceDayEnd: String, raceMonthEnd: String) -> Int {
//        let dateStartFormatted = makeDate(year: 2019, month: Int(raceMonthStart)!, day: Int(raceDayStart)!)
//        var dateEndFormatted = Date()
//        if raceDayEnd == "" || raceMonthEnd == "" {
//            dateEndFormatted = dateStartFormatted
//        } else {
//            dateEndFormatted = makeDate(year: 2019, month: Int(raceMonthEnd)!, day: Int(raceDayEnd)!)
//        }
//        
//        let currentDate = Date()
//        
//        if dateEndFormatted > currentDate {
//            return RACE_INACTIVE
//        } else if dateStartFormatted >= currentDate && dateEndFormatted <= currentDate{
//            return RACE_ACTIVE
//        } else {
//            return RACE_END
//        }
//    }
    
//    func makeDate(year: Int, month: Int, day: Int) -> Date {
//        var calendar = Calendar(identifier: .gregorian)
//        // calendar.timeZone = TimeZone(secondsFromGMT: 0)!
//        let components = DateComponents(year: year, month: month, day: day)
//        return calendar.date(from: components)!
//    }
}
