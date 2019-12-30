//
//  CalendarViewController.swift
//  Angliru
//
//  Created by Juanra Fernández on 31/07/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit
import SVProgressHUD

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CalendarPresenterOutput {

    @IBOutlet weak var tableView: UITableView!
    
    var races = Array<Race>()
    var presenter = CalendarPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: Helpers
    private func setup() {
        presenter.output = self
        SVProgressHUD.show()
        presenter.getCalendarRaces(season: "2019")
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    
    // MARK: Actions
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.tableView.refreshControl?.endRefreshing()
            }
            self?.tableView.reloadData()
        })
    }
    
    //MARK: UITableViewDelegate methods
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return races.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarInfoCell", for: indexPath) as! CalendarInfoCell
        let race = races[indexPath.row]
        cell.labelRaceName.text = race.name
        
        var position = race.dateStart.firstIndex(of: ".") ?? race.dateStart.endIndex
        let dateNumber = String(race.dateStart[..<position])
        position = race.dateStart.index(position, offsetBy: 1)
        let dateMonth = String(race.dateStart[position...])
        
        cell.labelDay.text = dateNumber
        cell.labelMonth.text = MONTHS_SHORT[Int(dateMonth)!-1]
        var dateNumberEnd = ""
        var dateMonthEnd = ""
        if race.dateEnd != "" {
            var positionEnd = race.dateEnd.firstIndex(of: ".") ?? race.dateEnd.endIndex
            dateNumberEnd = String(race.dateEnd[..<positionEnd])
            positionEnd = race.dateEnd.index(positionEnd, offsetBy: 1)
            dateMonthEnd = String(race.dateEnd[positionEnd...])
            cell.labelRaceDate.text = "\(dateNumber) \(MONTHS_SHORT[Int(dateMonth)!]) - \(dateNumberEnd) \(MONTHS_SHORT[Int(dateMonthEnd)!])"
        } else {
            cell.labelRaceDate.text = "\(dateNumber) \(MONTHS_SHORT[Int(dateMonth)!])"
        }
        if race.distance != 0 {
            cell.labelRaceDistance.isHidden = false
            cell.labelRaceDistance.text = "\(String(race.distance)) km"
        } else {
            cell.labelRaceDistance.isHidden = true
        }
        
        if race.stages.count > 0 {
            cell.labelRaceType.text = "\(race.stages.count) Etapas"
        } else {
            cell.labelRaceType.text = "CLÁSICA"
        }
        
        return cell
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 138
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let race = races[indexPath.row]
    }
    
    //MARK: CalendarPresenterOutput methods
    
    func presenterDidReceiveCalendarRaces(calendarRaces: Array<Race>) {
        races = calendarRaces.sorted{$0.position < $1.position}
        
        tableView.reloadData()
        SVProgressHUD.dismiss()
    }
    
    func presenterDidReceiveCalendarRacesError(error:Error) {
        SVProgressHUD.dismiss()
    }
}
