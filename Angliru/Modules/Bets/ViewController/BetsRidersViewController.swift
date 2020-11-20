//
//  BetsRidersViewController.swift
//  Angliru
//
//  Created by Juanra Fernández on 09/09/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit
import SVProgressHUD

class BetsRidersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ClassificationPresenterOutput, BetsPresenterOutput {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonSave: UIButton!
    
    var team = ""
    var race = Race()
    var season = ""
    //var riders = Array<Classification>()
    var presenterClassification = ClassificationPresenter()
    var presenter = BetsPresenter()
    var selectedRider = RiderJDO()
    var teamRiders = [RiderJDO]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "BetRiderCell", bundle: nil), forCellReuseIdentifier: "BetRiderCell")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        presenterClassification.output = self
        presenter.output = self
        //reloadInfo()
    }
    
    func reloadInfo() {
        SVProgressHUD.show()
        presenter.getBetsOpen(season: season, raceName: race.name)
        presenterClassification.getTeamRidersByRace(season: season, teamName: team, raceName: race.name)
        tableView.reloadData()
    }
    
    @IBAction func buttonBack_clicked(_ sender: Any) {
        self.navigationController! .popViewController(animated: true)
    }
    
    @IBAction func buttonSaveBet_clicked(_ sender: Any) {
        presenter.saveBet(raceName: race.name, riderName: selectedRider.name, season: "2019", typeBet: "GC")
    }
    
    // MARK: TableView delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamRiders.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BetRiderCell", for: indexPath) as! BetRiderCell
        let rider = teamRiders[indexPath.row]
        //cell.imageViewCountry.image = UIImage(named: classification.country)
        cell.labelName.text = rider.name
        cell.labelTeam.text = rider.team
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
        for row in 0..<numberOfRows {
            if let cell = tableView.cellForRow(at: NSIndexPath(row: row, section: indexPath.section) as IndexPath) {
                cell.accessoryType = .none
                //buttonSave.isEnabled = false
            }
        }
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
                //buttonSave.isEnabled = true
                selectedRider = teamRiders[indexPath.row]
            } else {
                cell.accessoryType = .none
            }
        }
    }
    
    func viewRiderInfo(rider:Rider) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "RiderInfoViewController") as! RiderInfoViewController
        //viewController.rider = rider
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: ClassificationPresenterOutput methods
    func presenterDidReceiveClassificationByType(classification: Array<Classification>, type: String) {
        
    }
    
    func presenterDidReceiveClassificationByTypeError(error:Error) {
        SVProgressHUD.dismiss()
    }
    
    func presenterDidReceiveTeamRidersByRace(result: Array<Classification>) {
//        riders = result
//        SVProgressHUD.dismiss()
//        tableView.reloadData()
    }
    
    func presenterDidReceiveTeamRidersByRaceError(error: Error) {
        
    }
    
    func presenterDidCheckClassificationRacesUpdates(updated: String) {
        
    }
    
    func presenterDidCheckClassificationRacesUpdatesError(error: Error) {
        
    }
    
    //MARK: BetsPresenterOutput methods
    func presenterDidSaveBet() {
        SVProgressHUD.dismiss()
    }
    
    func presenterDidSaveBetError(error: Error) {
        SVProgressHUD.dismiss()
    }
    
    func presenterGetBetsOpen(result: Bool) {
        buttonSave.isEnabled = result
    }
    
    func presenterGetBetsOpenError(error: Error) {
        
    }
    
    func presenterDidGetRaceTeams(result: Array<RiderJDO>) {
        
    }
    
    func presenterDidGetRaceTeamsError(error: Error) {
        
    }
}

