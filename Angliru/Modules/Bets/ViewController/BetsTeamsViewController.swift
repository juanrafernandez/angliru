//
//  BetsRidersViewController.swift
//  Angliru
//
//  Created by Juanra Fernández on 06/09/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit
import SVProgressHUD

class BetsTeamsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, TeamsPresenterOutput {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter = TeamsPresenter()
    var teams = [[Team]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.output = self
        initializeVariables()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        loadInfo()
    }
    
    func initializeVariables() {
        labelTitle.text = "Equipos 2019"
        for _ in 0..<CATEGORIES.count {
            let aux = [Team]()
            teams.append(aux)
        }
    }
    
    func loadInfo() {
        SVProgressHUD.show()
        tableView.reloadData()
        for i in 0..<CATEGORIES.count {
            presenter.getTeams(season: "2019", category: CATEGORIES[i])
        }
    }
    
    func viewTeamRiders(team:Team) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "TeamInfoViewController") as! TeamInfoViewController
        if team.name != "" {
            viewController.team = team
        }
        viewController.season = "2019"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func buttonBack_clicked(_ sender: Any) {
        self.navigationController! .popViewController(animated: true)
    }
    
    // MARK: TableView delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return CATEGORIES.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return teams[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return CATEGORIES[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = teams[indexPath.section][indexPath.row].name
        cell.imageView?.image = UIImage(named: teams[indexPath.section][indexPath.row].country)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //viewTeamInfo(team: teams[indexPath.section][indexPath.row])
    }
    
    //MARK: CyclingInfoPresenterOutput methods
    func presenterDidGetTeams(result:Array<Team>,category:String) {
        let index = CATEGORIES.firstIndex(of: category)
        teams[index!] = result
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
    
}
