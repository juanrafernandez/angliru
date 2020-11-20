//
//  CalendarViewController.swift
//  Angliru
//
//  Created by Juanra Fernández on 31/07/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit
import SVProgressHUD
import BTNavigationDropdownMenu

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CalendarPresenterOutput {
    
    @IBOutlet weak var tableView: UITableView!
    
    var races = Array<Race>()
    var presenter = CalendarPresenter()
    var menuView: BTNavigationDropdownMenu!
    //let CURRENT_SEASON = "2019"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeInterface()
        loadSeasonDate()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: Helpers
    private func initializeInterface() {
        presenter.output = self
        SVProgressHUD.show()
        //presenter.getCalendarRaces(season: "2019")
        var season = UserDefaults.standard.object(forKey: SEASON_SELECTED)
        if season == nil {
            season = "2019"
        }
        season = "2019"
        presenter.checkCalendarRacesUpdates(season: season as! String)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    
    func loadSeasonDate () {
        //buttonAdd.layer.cornerRadius = 25
        
        self.navigationController?.view.backgroundColor = .black
        
        let date = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: date)
        let nextYearDate = calendar.date(byAdding: .year, value: 1, to: Date())
        let nextYear = String(calendar.component(.year, from: nextYearDate!))
        var items = [nextYear, String(currentYear)]
        
        if (UserDefaults.standard.string(forKey: SEASON_SELECTED) == nil) {
            UserDefaults.standard.set(items[1], forKey: SEASON_SELECTED)
        }
        
        for i in MINIMUN_YEAR_BBDD..<currentYear{
            items.append(String(i))
        }
        
        //self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 236.0/255.0, green:236.0/255.0, blue:236.0/255.0, alpha: 1.0)
        //self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        //self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.backgroundColor: UIColor.red]
        
        let index = items.firstIndex(of: UserDefaults.standard.string(forKey: SEASON_SELECTED) ?? String(currentYear))
        if ((self.parent?.navigationController) != nil) {
            menuView = BTNavigationDropdownMenu(navigationController: self.parent?.navigationController, containerView: (self.parent?.navigationController!.view)!, title: BTTitle.index(index!), items: items)
        } else {
            menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: BTTitle.index(index!), items: items)
        }
        menuView.arrowTintColor = .black
        menuView.cellSelectionColor = .black
        menuView.checkMarkImage = UIImage(named: "ic_back")
        menuView.cellBackgroundColor = UIColor(red: 236.0/255.0, green:236.0/255.0, blue:236.0/255.0, alpha: 1.0)
        
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        //menuView.cellSelectionColor = UIColor(red: 0.0/255.0, green:160.0/255.0, blue:195.0/255.0, alpha: 1.0)
        menuView.cellSelectionColor = UIColor(red: 236.0/255.0, green:236.0/255.0, blue:236.0/255.0, alpha: 1.0)
        self.menuView.arrowTintColor = COLOR_ORANGE
        menuView.shouldKeepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.black
        menuView.navigationBarTitleFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
        menuView.cellTextLabelFont = UIFont.systemFont(ofSize: 17, weight: .semibold) //UIFont(name: "System-Semibold", size: 20)
        menuView.cellTextLabelAlignment = .left // .Center // .Right // .Left
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.black
        menuView.maskBackgroundOpacity = 0.3
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> Void in
            
            UserDefaults.standard.set(items[indexPath], forKey: SEASON_SELECTED)
            //self.configureView()
            self.initializeInterface()
            
        }
        
        self.navigationItem.titleView = menuView
    }
    
    func viewCalendarRace(race: Race) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let calendarPopUp = storyboard.instantiateViewController(withIdentifier: "CalendarRaceViewController") as! CalendarRaceViewController
        calendarPopUp.race = race
        calendarPopUp.navigationParent = self.navigationController
        self.present(calendarPopUp, animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }
    
//    func viewCalendarPopUp(race: Race) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let calendarPopUp = storyboard.instantiateViewController(withIdentifier: "CalendarPopUpViewController") as! CalendarPopUpViewController
//        calendarPopUp.race = race
//        calendarPopUp.navigationParent = self.navigationController
//        self.present(calendarPopUp, animated: true, completion: nil)
//        SVProgressHUD.dismiss()
//    }
    
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
        cell.setCellData(race: race)
                
        return cell
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 138
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SVProgressHUD.show()
        let race = races[indexPath.row]
        viewCalendarRace(race: race)
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
    
    func presenterDidCheckCalendarRacesUpdates(updated: String) {
        let savedDate = UserDefaults.standard.string(forKey: "\(LAST_UPDATE_CALENDAR_KEY)\(CURRENT_SEASON)") ?? ""
        if savedDate == "" || Utils.getDateFrom(stringDate: savedDate) > Utils.getDateFrom(stringDate: updated) {
            //Request info from server
            UserDefaults.standard.set(updated, forKey: "\(LAST_UPDATE_CALENDAR_KEY)\(CURRENT_SEASON)")
            presenter.getCalendarRaces(season: CURRENT_SEASON, cache: false)
        } else {
            presenter.getCalendarRaces(season: CURRENT_SEASON, cache: true)
        }
    }
    
    func presenterDidCheckCalendarRacesUpdatesError(error: Error) {
        SVProgressHUD.dismiss()
    }
    
    func presenterDidGetRaceTeams(riders: Array<Rider>) {
        
    }
    
    func presenterDidGetRaceTeamsError(error: Error) {
        
    }
}
