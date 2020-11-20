//
//  ClassificationViewController.swift
//  Angliru
//
//  Created by Juanra Fernández on 02/08/2019.
//  Copyright © 2019 JRLabs. All rights reserved.
//

import UIKit
import SVProgressHUD

class ClassificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ClassificationPresenterOutput {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    var racesResults = Array<[Classification]>()
    var classificationTypes = Array<String>()
    var raceName = ""
    var season = ""
    var presenter = ClassificationPresenter()
    var classificationIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.output = self
        presenter.checkClassificationRacesUpdates(season: CURRENT_SEASON)
        //initilizeInterface()
        tableView.register(UINib(nibName: "ClassificationCell", bundle: nil), forCellReuseIdentifier: "ClassificationCell")
        tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        segmentControl.removeAllSegments()
    }
    
    func initilizeInterface() {
        if classificationTypes.count > 0 {
            for i in 0..<classificationTypes.count {
                segmentControl.insertSegment(withTitle: classificationTypes[i], at: i, animated: true)
            }
            segmentControl.selectedSegmentIndex = 0
        }
    }
    
    func reloadInfo(cache:Bool) {
     //   segmentControl.removeAllSegments()
//        if classificationTypes.count > 0 {
//            for i in 0..<classificationTypes.count {
//                segmentControl.insertSegment(withTitle: classificationTypes[i], at: i, animated: true)
//            }
//            segmentControl.selectedSegmentIndex = 0
//        } else {
            if raceName != "" {
                SVProgressHUD.show()
                for i in 0..<CLASSIFICATION_TYPES.count {
                    presenter.getClassificationByType(raceName: raceName, season: season, type: CLASSIFICATION_TYPES[i],cache:cache)
                }
            }
       // }
    }
    
    // MARK: - Actions ⚡️
    @IBAction func segmentControl_valueChanged(_ sender: Any) {
        tableView.reloadData()
    }
    
    @IBAction func buttonBack_clicked(_ sender: Any) {
        self.navigationController! .popViewController(animated: true)
    }
    // MARK: UITableView Delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if classificationTypes.count > 0 {
            if segmentControl.selectedSegmentIndex == -1 {
                return racesResults[0].count
            } else {
                return racesResults[segmentControl.selectedSegmentIndex].count
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassificationCell", for: indexPath) as! ClassificationCell
        var raceIndex = segmentControl.selectedSegmentIndex
        if raceIndex == -1 {
            raceIndex = 0
        }
        
        let classification = racesResults[raceIndex][indexPath.row]
        cell.labelPosition.text = String(indexPath.row + 1)
        cell.labelName.text = classification.name
        cell.imageViewCountry.image = UIImage(named: classification.country)
        if classification.teamAbreviation == "" {
            cell.labelTeam.text = classification.team.uppercased()
        } else {
            cell.labelTeam.text = classification.teamAbreviation
        }
        if classification.time != "" {
            cell.labelTime.text = classification.time
        } else {
            cell.labelTime.text = classification.points
        }
        
        return cell
    }
    
    //MARK: ClassificationPresenterOutput methods
    func presenterDidReceiveClassificationByType(classification: Array<Classification>, type: String) {
        
        if classification.count > 0 {
            //racesResponse.racesResults[CLASSIFICATION_TYPES.firstIndex(of: type)!] = classification
            racesResults.append(classification)
            classificationTypes.append(type)
        }
        
        //if CLASSIFICATION_TYPES[CLASSIFICATION_TYPES.count-1] == type {
        if classificationIndex == CLASSIFICATION_TYPES.count-1 && classificationTypes.count>0{
            initilizeInterface()
            tableView.reloadData()
            SVProgressHUD.dismiss()
        } else {
            tableView.reloadData()
            SVProgressHUD.dismiss()
        }
        
        classificationIndex += 1
    }
    
    func presenterDidReceiveClassificationByTypeError(error:Error) {
        SVProgressHUD.dismiss()
    }
    
    func presenterDidReceiveTeamRidersByRace(result: Array<Classification>) {
        
    }
    
    func presenterDidReceiveTeamRidersByRaceError(error: Error) {
        
    }
    
    func presenterDidCheckClassificationRacesUpdates(updated: String) {
        let savedDate = UserDefaults.standard.string(forKey: "\(LAST_UPDATE_RACES_KEY)\(CURRENT_SEASON)") ?? ""
        if savedDate == "" || Utils.getDateFrom(stringDate: savedDate) > Utils.getDateFrom(stringDate: updated) {
            //Request info from server
            UserDefaults.standard.set(updated, forKey: "\(LAST_UPDATE_RACES_KEY)\(CURRENT_SEASON)")
            reloadInfo(cache: false)
            //presenter.getCalendarRaces(season: CURRENT_SEASON, cache: false)
        } else {
            reloadInfo(cache: true)
            //presenter.getCalendarRaces(season: CURRENT_SEASON, cache: true)
        }
    }
    
    func presenterDidCheckClassificationRacesUpdatesError(error: Error) {
        
    }
}
