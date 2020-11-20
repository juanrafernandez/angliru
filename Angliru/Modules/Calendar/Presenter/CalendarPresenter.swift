//
//  CalendarPresenter.swift
//  Angliru
//
//  Created by Juanra Fernández on 01/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import Foundation
import UIKit

protocol CalendarPresenterInput {
    func getCalendarRaces(season: String, cache: Bool)
    func checkCalendarRacesUpdates(season:String)
    
}

protocol CalendarPresenterOutput {
    func presenterDidReceiveCalendarRaces(calendarRaces: Array<Race>)
    func presenterDidReceiveCalendarRacesError(error:Error)
    func presenterDidCheckCalendarRacesUpdates(updated: String)
    func presenterDidCheckCalendarRacesUpdatesError(error: Error)
}

class CalendarPresenter: NSObject, CalendarPresenterInput {
    
    var output : CalendarPresenterOutput!
    var dataManager : CalendarDataManager!
    
    override init() {
        dataManager = CalendarDataManager()
    }
    
    func checkCalendarRacesUpdates(season:String) {
        dataManager.checkCalendarRacesUpdates(season: season, success: { (result) in
            if (self.output != nil) {
                self.output.presenterDidCheckCalendarRacesUpdates(updated: result)
            }
        }) { (error) in
            self.output.presenterDidCheckCalendarRacesUpdatesError(error: error)
        }
    }
    
    func getCalendarRaces(season: String, cache: Bool) {
        dataManager.getCalendarRaces(season: season, cache: cache, success: { (result) in
            if (self.output != nil) {
                self.output.presenterDidReceiveCalendarRaces(calendarRaces: result)
            }
        }) { (err) in
            if (self.output != nil) {
                self.output.presenterDidReceiveCalendarRacesError(error: err)
            }
        }
    }
}

