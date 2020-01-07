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
    
    func viewCalendarPopUp(race: Race) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let calendarPopUp = storyboard.instantiateViewController(withIdentifier: "CalendarPopUpViewController") as! CalendarPopUpViewController
        calendarPopUp.race = race
        self.present(calendarPopUp, animated: true, completion: nil)
        SVProgressHUD.dismiss()
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
        cell.setCellData(race: race)
                
        return cell
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 138
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SVProgressHUD.show()
        let race = races[indexPath.row]
        viewCalendarPopUp(race: race)
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
