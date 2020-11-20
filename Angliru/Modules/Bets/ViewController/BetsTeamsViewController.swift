//
//  BetsRidersViewController.swift
//  Angliru
//
//  Created by Juanra Fernández on 06/09/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit
import SVProgressHUD

class BetsTeamsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, BetsPresenterOutput {
        
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var race = Race()
    //var teams = [Team]()
    var teams = [String]()
    var riders = [RiderJDO]()
    var presenter = BetsPresenter()
    var season = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitle.text = "Seleccione Equipo de Corredor"
        
        //initializeVariables()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        presenter.output = self
        initializeVariables()
    }
    
    func initializeVariables() {
//        for rider in race.riders {
//            if !teams.contains(rider.team) {
//                teams.append(rider.team)
//            }
//        }
        SVProgressHUD.show()
        presenter.getRaceTeams(raceName: race.name, season: CURRENT_SEASON)
    }
    
    func viewTeamRidersByRace(team:String, riders: Array<RiderJDO>) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "BetsRidersViewController") as! BetsRidersViewController
        viewController.team = team
        viewController.teamRiders = riders
        viewController.race = race
        viewController.season = "2019"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func buttonBack_clicked(_ sender: Any) {
        self.navigationController! .popViewController(animated: true)
    }
    
    // MARK: TableView delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = teams[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let teamRiders = riders.filter({$0.team == teams[indexPath.row]})
        viewTeamRidersByRace(team: teams[indexPath.row], riders: teamRiders)
    }
    
    //MARK: BetsPresenterOutput methods
    func presenterDidGetRaceTeams(result: Array<RiderJDO>) {
        for riderJDO in result {
            if !teams.contains(riderJDO.team) {
                teams.append(riderJDO.team)
            }
        }
//
//            var rider = Rider()
//            rider.team = riderJDO.team
//            rider.name = riderJDO.name
//            riders.append(rider)
//        }
        riders = result
        tableView.reloadData()
        SVProgressHUD.dismiss()
    }
    
    func presenterDidGetRaceTeamsError(error: Error) {
        SVProgressHUD.dismiss()
    }
    
    func presenterDidSaveBet() {
        SVProgressHUD.dismiss()
    }
    
    func presenterDidSaveBetError(error: Error) {
        SVProgressHUD.dismiss()
    }
    
    func presenterGetBetsOpen(result: Bool) {
        SVProgressHUD.dismiss()
    }
    
    func presenterGetBetsOpenError(error: Error) {
        SVProgressHUD.dismiss()
    }
}
