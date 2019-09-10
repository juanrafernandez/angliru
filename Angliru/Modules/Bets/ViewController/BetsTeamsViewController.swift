//
//  BetsRidersViewController.swift
//  Angliru
//
//  Created by Juanra Fernández on 06/09/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit
import SVProgressHUD

class BetsTeamsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var race = Race()
    var teams = [Team]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitle.text = "Equipos 2019"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
       
    }
    
    func viewTeamRidersByRace(team:String) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "BetsRidersViewController") as! BetsRidersViewController
        viewController.team = team
        viewController.race = race
        viewController.season = "2019"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func buttonBack_clicked(_ sender: Any) {
        self.navigationController! .popViewController(animated: true)
    }
    
    // MARK: TableView delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return race.teams.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = race.teams[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewTeamRidersByRace(team: race.teams[indexPath.row])
    }
    
}
