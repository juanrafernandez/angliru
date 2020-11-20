//
//  TeamsViewController.swift
//  Angliru
//
//  Created by Juanra Fernández on 05/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit
import SVProgressHUD

class TeamsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TeamsPresenterOutput, UISearchBarDelegate {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentCategories: UISegmentedControl!
    
    var presenter = TeamsPresenter()
    var teams = [[Team]]()
    var teamsFiltered = [[Team]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.output = self
        initializeVariables()
        tableView.register(UINib(nibName: "TeamCell", bundle: nil), forCellReuseIdentifier: "TeamCell")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        //loadInfo()
        presenter.checkTeamsUpdates(season: CURRENT_SEASON)
    }

    func initializeVariables() {
        labelTitle.text = "Equipos 2019"
        for _ in 0..<CATEGORIES.count {
            let aux = [Team]()
            teams.append(aux)
        }
        teamsFiltered = teams
    }
    
    func reloadInfo(cache:Bool) {
        SVProgressHUD.show()
        tableView.reloadData()
        for i in 0..<CATEGORIES.count {
            presenter.getTeams(season: CURRENT_SEASON, category: CATEGORIES[i], cache: cache)
        }
    }
    
    func viewTeamInfo(team:Team) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "TeamInfoViewController") as! TeamInfoViewController
        if team.name != "" {
            viewController.team = team
        }
        viewController.season = CURRENT_SEASON
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func segmentCategories_valueChanged(_ sender: Any) {
        
    }
    
    // MARK: TableView delegate methods
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return CATEGORIES.count
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return teams[0].count
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return CATEGORIES[section]
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as! TeamCell
        cell.labelName.text = teams[indexPath.section][indexPath.row].name
        //cell.imageView?.image = UIImage(named: teams[indexPath.section][indexPath.row].country)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewTeamInfo(team: teams[indexPath.section][indexPath.row])
    }

    //MARK: CyclingInfoPresenterOutput methods
    func presenterDidGetTeams(result:Array<Team>,category:String) {
        let index = CATEGORIES.firstIndex(of: category)
        teams[index!] = result
        teamsFiltered[index!] = result
        tableView.reloadData()
        SVProgressHUD.dismiss()
    }
    
    func presenterDidGetTeamsError(error:Error) {
        print(error)
        SVProgressHUD.dismiss()
    }
    
    func presenterDidReceiveTeamRiders(result : Array<Rider>) {
        
    }
    
    func presenterDidReceiveTeamRidersError(error : Error) {
        
    }
    
    func presenterDidCheckTeamsUpdates(updated: String) {
        let savedDate = UserDefaults.standard.string(forKey: "\(LAST_UPDATE_TEAMS_KEY)\(CURRENT_SEASON)") ?? ""
        
        if savedDate == "" || Utils.getDateFrom(stringDate: savedDate) > Utils.getDateFrom(stringDate: updated) {
            //Request info from server
            UserDefaults.standard.set(updated, forKey: "\(LAST_UPDATE_TEAMS_KEY)\(CURRENT_SEASON)")
            //presenter.getCalendarRaces(season: CURRENT_SEASON, cache: false)
            reloadInfo(cache: false)
        } else {
            //presenter.getCalendarRaces(season: CURRENT_SEASON, cache: true)
            reloadInfo(cache: true)
        }
    }
    
    func presenterDidCheckTeamsUpdatesError(error: Error) {
        SVProgressHUD.dismiss()
    }
    
    //MARK:UISearchBarDelegate methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            teamsFiltered = teams
        } else {
            teamsFiltered = [[Team]]()
            
            
            for index in teams {
//                let sectionRiders = indexedRiders[section]?.filter({$0.name.uppercased().contains(searchText.uppercased())})
//                if sectionRiders!.count > 0 {
//                    indexedRidersFiltered[section] = sectionRiders
//                }
            }
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
